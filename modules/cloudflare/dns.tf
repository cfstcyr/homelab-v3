locals {
  dns_comment = "Cloudflare Tunnel for reverse proxy on ${var.namespace}. This is managed by Terraform."
}

resource "cloudflare_record" "reverse_proxy_root" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  content = cloudflare_zero_trust_tunnel_cloudflared.reverse_proxy.cname
  type    = "CNAME"
  proxied = true
  comment = local.dns_comment
}

resource "cloudflare_record" "reverse_proxy_subdomains" {
  zone_id = var.cloudflare_zone_id
  name    = "*"
  content = cloudflare_zero_trust_tunnel_cloudflared.reverse_proxy.cname
  type    = "CNAME"
  proxied = true
  comment = local.dns_comment
}