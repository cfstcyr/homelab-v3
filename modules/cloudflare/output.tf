output "tunnel_reverse_proxy_token" {
  value     = cloudflare_zero_trust_tunnel_cloudflared.reverse_proxy.tunnel_token
  sensitive = true
}

# Certificates

output "origin_cert" {
  value = cloudflare_origin_ca_certificate.certificate.certificate
}

output "private_key" {
  value     = tls_cert_request.certificate.cert_request_pem
  sensitive = true
}