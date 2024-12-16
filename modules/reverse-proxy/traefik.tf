resource "kubernetes_deployment" "traefik" {
  metadata {
    name = var.traefik_app
    namespace = var.namespace

    labels = {
      app = var.traefik_app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.traefik_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.traefik_app
          config_hash = local.traefik_config_hash
          providers_hash = local.traefik_config_providers_hash
        }
      }

      spec {
        service_account_name = kubernetes_service_account.traefik.metadata[0].name

        volume {
          name = "${var.traefik_app}-config"

          config_map {
            name = kubernetes_config_map.traefik_config.metadata.0.name
          }
        }

        volume {
          name = "${var.traefik_app}-config-providers"

          config_map {
            name = kubernetes_config_map.traefik_config_providers.metadata.0.name
          }
        }

        container {
          name = var.traefik_app
          image = "traefik:v3.2"
          
          port {
            container_port = 80
          }

          port {
            container_port = 8080
          }

          volume_mount {
            name = "${var.traefik_app}-config"
            mount_path = "/etc/traefik/"
            read_only = true
          }

          volume_mount {
            name = "${var.traefik_app}-config-providers"
            mount_path = "/etc/traefik/providers/"
            read_only = true
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "traefik" {
  metadata {
    name = var.traefik_app
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.traefik_app
    }

    type = "LoadBalancer" # Magic line: allows the service to be exposed externally

    port {
      name = "http"
      port = 80
      target_port = 80
    }

    port {
      name = "dashboard"
      port = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress_v1" "dashboard" {
  metadata {
    name      = "${var.traefik_app}-dashboard"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled": "true",
      "gethomepage.dev/name": "Traefik",
      "gethomepage.dev/icon": "traefik",
      "gethomepage.dev/group": "Tools",
      "gethomepage.dev/pod-selector": "",
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.traefik_subdomain != null ? "${var.traefik_subdomain}.${rule.value}" : rule.value

        http {
          path {
            path = "/"

            backend {
              service {
                name = "traefik"
                port {
                  number = 8080
                }
              }
            }
          }
        }
      }
    }
  }
}