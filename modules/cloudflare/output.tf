output "tunnel_reverse_proxy_token" {
  value     = cloudflare_zero_trust_tunnel_cloudflared.reverse_proxy.tunnel_token
  sensitive = true
}
