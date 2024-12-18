resource "kubernetes_deployment" "traefik" {
  metadata {
    name      = var.traefik_app
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
          app            = var.traefik_app
          config_hash    = module.traefik_config.hash
          providers_hash = module.traefik_config_providers.hash
        }
      }

      spec {
        service_account_name = kubernetes_service_account.traefik.metadata[0].name

        volume {
          name = "${var.traefik_app}-config"

          config_map {
            name = module.traefik_config.config_map
          }
        }

        volume {
          name = "${var.traefik_app}-config-providers"

          config_map {
            name = module.traefik_config_providers.config_map
          }
        }

        volume {
          name = "${var.traefik_app}-acme"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.acme.metadata[0].name
          }
        }

        container {
          name  = var.traefik_app
          image = "traefik:v3.2"

          port {
            container_port = 80
          }

          port {
            container_port = 8080
          }

          env {
            name  = "CF_DNS_API_TOKEN"
            value = var.cloudflare_api_token
          }

          volume_mount {
            name       = "${var.traefik_app}-config"
            mount_path = "/etc/traefik/"
            read_only  = true
          }

          volume_mount {
            name       = "${var.traefik_app}-config-providers"
            mount_path = "/etc/traefik/providers/"
            read_only  = true
          }

          volume_mount {
            name       = "${var.traefik_app}-acme"
            mount_path = "/etc/traefik/acme/"
            read_only  = false
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "traefik_http" {
  metadata {
    name      = "${var.traefik_app}-http"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.traefik_app
    }

    type = "LoadBalancer" # Magic line: allows the service to be exposed externally

    port {
      name        = "http"
      port        = 80
      target_port = 80
    }

    port {
      name        = "https"
      port        = 443
      target_port = 443
    }
  }
}

resource "kubernetes_service" "traefik_dashboard" {
  metadata {
    name      = "${var.traefik_app}-dashboard"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.traefik_app
    }

    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }
  }
}

resource "kubernetes_ingress_v1" "dashboard" {
  metadata {
    name      = "${var.traefik_app}-dashboard"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Traefik",
      "gethomepage.dev/icon" : "traefik",
      "gethomepage.dev/group" : "Tools",
      "gethomepage.dev/weight" : "30",
      "gethomepage.dev/widget.type" : "traefik",
      "gethomepage.dev/widget.url" : "http://${kubernetes_service.traefik_dashboard.metadata[0].name}:8080",
      "gethomepage.dev/pod-selector" : "app=${var.traefik_app}"
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
                name = kubernetes_service.traefik_dashboard.metadata[0].name
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