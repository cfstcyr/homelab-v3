resource "kubernetes_deployment" "pgadmin" {
  metadata {
    name      = var.pgadmin_app
    namespace = var.namespace
    labels = {
      app = var.pgadmin_app
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = var.pgadmin_app
      }
    }
    template {
      metadata {
        labels = {
          app = var.pgadmin_app
        }
      }
      spec {
        container {
          name  = var.pgadmin_app
          image = "dpage/pgadmin4:latest"

          env {
            name  = "PGADMIN_DEFAULT_EMAIL"
            value = var.pgadmin_default_email
          }

          env {
            name  = "PGADMIN_DEFAULT_PASSWORD"
            value = var.pgadmin_default_password
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pgadmin" {
  metadata {
    name      = var.pgadmin_app
    namespace = var.namespace
    labels = {
      app = var.pgadmin_app
    }
  }

  spec {
    selector = {
      app = var.pgadmin_app
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_ingress_v1" "pgadmin" {
  metadata {
    name      = var.pgadmin_app
    namespace = var.namespace

    annotations = {
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure"
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "pgAdmin",
      "gethomepage.dev/icon" : "pgadmin",
      "gethomepage.dev/group" : "Tools",
      "gethomepage.dev/weight" : "30",
      "gethomepage.dev/pod-selector" : "app=${var.pgadmin_app}"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.pgadmin_subdomain != null ? "${var.pgadmin_subdomain}.${rule.value}" : rule.value

        http {
          path {
            path = "/"

            backend {
              service {
                name = var.pgadmin_app

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