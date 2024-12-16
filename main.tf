resource "kubernetes_namespace" "homelab" {
  metadata {
    name = "homelab-v3"
  }
}

module "reverse-proxy" {
  source = "./modules/reverse-proxy"

  namespace = kubernetes_namespace.homelab.metadata.0.name
  config_path = "${path.module}/config"

  reverse_proxy_domains = var.reverse_proxy_domains
  traefik_subdomain = var.traefik_subdomain
}

module "homepage" {
  source = "./modules/homepage"

  namespace = kubernetes_namespace.homelab.metadata.0.name
  config_path = "${path.module}/config"

  reverse_proxy_domains = var.reverse_proxy_domains
  homepage_subdomain = var.homepage_subdomain
}