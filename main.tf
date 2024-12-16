resource "kubernetes_namespace" "homelab" {
  metadata {
    name = "homelab-v3"
  }
}

module "reverse-proxy" {
  source = "./modules/reverse-proxy"

  namespace = kubernetes_namespace.homelab.metadata.0.name

  config_path = "${path.module}/config"
}
