resource "kubernetes_stateful_set" "home_assistant" {
  metadata {
    name = var.home_assistant_app
    namespace = var.namespace

    labels = {
      app = var.home_assistant_app
    }
  }

  spec {
    service_name = var.home_assistant_app
    replicas = 1

    selector {
      match_labels = {
        app = var.home_assistant_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.home_assistant_app
        }
      }

      spec {
        service_account_name = kubernetes_service_account.home_assistant_sa.metadata[0].name

        volume {
          name = "${var.home_assistant_app}-dbus"

          host_path {
            path = "/run/dbus"
          }
        }

        volume {
          name = "${var.home_assistant_app}-config-file"

          config_map {
            name = kubernetes_config_map.home_assistant_config.metadata[0].name

            items {
              key  = local.config_file
              path = local.config_file
            }
          }
        }

        container {
          name = var.home_assistant_app
          image = "ghcr.io/home-assistant/home-assistant:stable"

          port {
            container_port = 8123
          }

          volume_mount {
            name = "${var.home_assistant_app}-dbus"
            mount_path = "/run/dbus"
          }

          volume_mount {
            name = "${var.home_assistant_app}-config"
            mount_path = "/config"
          }

          volume_mount {
            name = "${var.home_assistant_app}-config-file"
            mount_path = "/config/${local.config_file}"
            sub_path   = local.config_file
          }

          security_context {
            capabilities {
              add = ["NET_ADMIN", "NET_RAW", "NET_BROADCAST"]
            }
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "${var.home_assistant_app}-config"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "500Mi"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "home_assistant" {
  metadata {
    name = var.home_assistant_app
    namespace = var.namespace

    labels = {
      app = var.home_assistant_app
    }
  }

  spec {
    selector = {
      app = var.home_assistant_app
    }

    port {
      port = 80
      target_port = 8123
    }
  }
}

resource "kubernetes_ingress_v1" "home_assistant" {
  metadata {
    name = var.home_assistant_app
    namespace = var.namespace

    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Home Assistant",
      "gethomepage.dev/icon" : "homeassistant",
      "gethomepage.dev/group" : "Tools",
      "gethomepage.dev/weight" : "20",
      "gethomepage.dev/pod-selector" : "app=${var.home_assistant_app}"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.home_assistant_subdomain != null ? "${var.home_assistant_subdomain}.${rule.value}" : rule.value

        http {
          path {
            path = "/"
            
            backend {
              service {
                name = var.home_assistant_app
                
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