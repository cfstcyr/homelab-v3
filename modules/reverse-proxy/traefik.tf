resource "kubernetes_deployment" "traefik" {
  metadata {
    name = local.traefik
    namespace = var.namespace

    labels = {
      app = local.traefik
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = local.traefik
      }
    }

    template {
      metadata {
        labels = {
          app = local.traefik
          config_hash = local.traefik_config_hash
          providers_hash = local.traefik_config_providers_hash
        }
      }

      spec {
        service_account_name = kubernetes_service_account.traefik.metadata[0].name

        volume {
          name = "${local.traefik}-config"

          config_map {
            name = kubernetes_config_map.traefik_config.metadata.0.name
          }
        }

        volume {
          name = "${local.traefik}-config-providers"

          config_map {
            name = kubernetes_config_map.traefik_config_providers.metadata.0.name
          }
        }

        container {
          name = local.traefik
          image = "traefik:v3.2"
          
          port {
            container_port = 80
          }

          port {
            container_port = 8080
          }

          volume_mount {
            name = "${local.traefik}-config"
            mount_path = "/etc/traefik/"
            read_only = true
          }

          volume_mount {
            name = "${local.traefik}-config-providers"
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
    name = local.traefik
    namespace = var.namespace
  }

  spec {
    selector = {
      app = local.traefik
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
    name      = "${local.traefik}-dashboard"
    namespace = var.namespace
  }

  spec {
    rule {
      host = "localhost"

      http {
        path {

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