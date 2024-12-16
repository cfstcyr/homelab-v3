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

module "media_management" {
  source = "./modules/media-management"

  namespace = kubernetes_namespace.homelab.metadata.0.name
  config_path = "${path.module}/config"
  vpn_env = var.vpn_env

  reverse_proxy_domains = var.reverse_proxy_domains
  radarr_subdomain = var.radarr_subdomain
  sonarr_subdomain = var.sonarr_subdomain
  prowlarr_subdomain = var.prowlarr_subdomain
  transmission_subdomain = var.transmission_subdomain

  library_movies_dir = var.library_movies_dir
  library_tv_dir = var.library_tv_dir
  downloads_dir = var.downloads_dir
}