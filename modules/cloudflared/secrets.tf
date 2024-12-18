resource "kubernetes_secret" "tunnel_token" {
  metadata {
    name      = "${var.cloudflared_app}-tunnel-token"
    namespace = var.namespace
  }

  data = {
    "tunnel_token" = var.cloudflare_tunnel_token
  }
}