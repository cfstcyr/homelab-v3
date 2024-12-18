resource "kubernetes_namespace" "homelab" {
  metadata {
    name = "homelab-v3"
  }
}

module "cloudflare" {
  source = "./modules/cloudflare"

  namespace = kubernetes_namespace.homelab.metadata[0].name

  reverse_proxy_hostname = module.reverse-proxy.reverse_proxy_hostname

  cloudflare_api_token   = var.cloudflare_api_token
  cloudflare_zone_id     = var.cloudflare_zone_id
  cloudflare_account_id  = var.cloudflare_account_id
  cloudflare_access_team = var.cloudflare_access_team

  cloudflare_admin_access = var.cloudflare_admin_access
}

module "metrics_server" {
  source = "./modules/metrics-server"

  namespace = kubernetes_namespace.homelab.metadata[0].name
}

module "reverse-proxy" {
  source = "./modules/reverse-proxy"

  namespace   = kubernetes_namespace.homelab.metadata[0].name
  config_path = abspath("${path.module}/config")

  reverse_proxy_domains = var.reverse_proxy_domains
  traefik_subdomain     = var.traefik_subdomain
}

module "homepage" {
  source = "./modules/homepage"

  namespace   = kubernetes_namespace.homelab.metadata[0].name
  config_path = abspath("${path.module}/config")

  reverse_proxy_domains = var.reverse_proxy_domains
  homepage_subdomain    = var.homepage_subdomain
}

module "media_management" {
  source = "./modules/media-management"

  namespace   = kubernetes_namespace.homelab.metadata[0].name
  config_path = abspath("${path.module}/config")
  vpn_env     = var.vpn_env

  reverse_proxy_domains  = var.reverse_proxy_domains
  radarr_subdomain       = var.radarr_subdomain
  sonarr_subdomain       = var.sonarr_subdomain
  prowlarr_subdomain     = var.prowlarr_subdomain
  transmission_subdomain = var.transmission_subdomain
  overseerr_subdomain    = var.overseerr_subdomain
  overseerr_api_key      = var.overseerr_api_key

  library_movies_dir = var.library_movies_dir
  library_tv_dir     = var.library_tv_dir
  downloads_dir      = var.downloads_dir
}

module "cloudflared" {
  source = "./modules/cloudflared"

  namespace = kubernetes_namespace.homelab.metadata[0].name

  cloudflare_tunnel_token = module.cloudflare.tunnel_reverse_proxy_token
}

# module "pi-hole" {
#   source = "./modules/pi-hole"

#   namespace   = kubernetes_namespace.homelab.metadata[0].name
#   config_path = abspath("${path.module}/config")

#   reverse_proxy_domains = var.reverse_proxy_domains
#   pi_hole_subdomain     = var.pi_hole_subdomain
# }