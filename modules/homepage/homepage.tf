resource "kubernetes_deployment" "homepage" {
  metadata {
    name = var.homepage_app
    namespace = var.namespace

    labels = {
      app = var.homepage_app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.homepage_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.homepage_app
          config_hash = module.homepage_config.hash
        }
      }

      spec {
        service_account_name = kubernetes_service_account.homepage.metadata.0.name

        volume {
          name = "${var.homepage_app}-config"

          config_map {
            name = module.homepage_config.config_map
          }
        }

        container {
          name = var.homepage_app
          image = "ghcr.io/gethomepage/homepage:latest"

          port {
            container_port = 3000
          }

          volume_mount {
            name = "${var.homepage_app}-config"
            mount_path = "/app/config"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "homepage" {
  metadata {
    name = var.homepage_app
    namespace = var.namespace

    labels = {
      app = var.homepage_app
    }
  }

  spec {
    selector = {
      app = var.homepage_app
    }

    port {
      port = 80
      target_port = 3000
    }
  }
}

resource "kubernetes_ingress_v1" "homepage" {
  metadata {
    name = var.homepage_app
    namespace = var.namespace
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.homepage_subdomain != null ? "${var.homepage_subdomain}.${rule.value}" : rule.value

        http {
          path {
            path = "/"

            backend {
              service {
                name = var.homepage_app
                port {
                  number = 80
                }
              }
            }
          }
        }
      }
    }
  }
}