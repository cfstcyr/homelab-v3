resource "random_password" "tunnel_secret" {
  length = 64
}

resource "cloudflare_zero_trust_tunnel_cloudflared" "reverse_proxy" {
  account_id = var.cloudflare_account_id
  name       = "${var.namespace}-reverse-proxy"
  secret     = base64sha256(random_password.tunnel_secret.result)
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "reverse_proxy" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.reverse_proxy.id
  account_id = var.cloudflare_account_id

  config {
    ingress_rule {
      hostname = cloudflare_record.reverse_proxy_root.hostname
      service  = "http://${var.reverse_proxy_hostname}"

      origin_request {
        origin_server_name = cloudflare_record.reverse_proxy_root.hostname

        access {
          required  = true
          team_name = var.cloudflare_access_team
          aud_tag = concat(
            length(cloudflare_zero_trust_access_application.reverse_proxy_public) > 0 ? [cloudflare_zero_trust_access_application.reverse_proxy_public[0].aud] : [],
            [cloudflare_zero_trust_access_application.reverse_proxy_admin.aud]
          )
        }
      }
    }

    ingress_rule {
      hostname = cloudflare_record.reverse_proxy_subdomains.hostname
      service  = "http://${var.reverse_proxy_hostname}"

      origin_request {
        origin_server_name = cloudflare_record.reverse_proxy_subdomains.hostname

        access {
          required  = true
          team_name = var.cloudflare_access_team
          aud_tag = concat(
            length(cloudflare_zero_trust_access_application.reverse_proxy_public) > 0 ? [cloudflare_zero_trust_access_application.reverse_proxy_public[0].aud] : [],
            [cloudflare_zero_trust_access_application.reverse_proxy_admin.aud]
          )
        }
      }
    }

    ingress_rule {
      service = "http_status:404"
    }
  }
}
