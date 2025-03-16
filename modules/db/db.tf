resource "kubernetes_stateful_set" "postgres" {
  metadata {
    name      = var.postgres_app
    namespace = var.namespace
  }

  spec {
    service_name = var.postgres_app
    replicas     = 1

    selector {
      match_labels = {
        app = var.postgres_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.postgres_app
        }
      }

      spec {
        service_account_name = kubernetes_service_account.postgres.metadata[0].name

        container {
          name  = var.postgres_app
          image = "postgres:latest"

          env {
            name = "POSTGRES_USER"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_auth.metadata[0].name
                key  = "username"
              }
            }
          }

          env {
            name = "POSTGRES_PASSWORD"

            value_from {
              secret_key_ref {
                name = kubernetes_secret.postgres_auth.metadata[0].name
                key  = "password"
              }
            }
          }

          volume_mount {
            name       = "${var.postgres_app}-storage"
            mount_path = "/var/lib/postgresql/data"
          }

          port {
            container_port = 5432
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "${var.postgres_app}-storage"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = var.postgres_capacity
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = var.postgres_app
    namespace = var.namespace
  }

  spec {
    selector = {
      app = var.postgres_app
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}