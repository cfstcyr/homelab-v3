resource "kubernetes_deployment" "cloudflared" {
  metadata {
    name      = var.cloudflared_app
    namespace = var.namespace

    labels = {
      app = var.cloudflared_app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.cloudflared_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.cloudflared_app
        }
      }

      spec {
        volume {
          name = "${var.cloudflared_app}-tunnel-token"

          secret {
            secret_name = kubernetes_secret.tunnel_token.metadata[0].name
          }
        }

        container {
          name  = var.cloudflared_app
          image = "cloudflare/cloudflared:latest"

          args = ["tunnel", "--no-tls-verify", "--no-autoupdate", "run"]

          volume_mount {
            name       = "${var.cloudflared_app}-tunnel-token"
            mount_path = "/secrets/cloudflared"
          }

          env {
            name  = "TUNNEL_TOKEN"
            value = var.cloudflare_tunnel_token
          }
        }
      }
    }
  }
}