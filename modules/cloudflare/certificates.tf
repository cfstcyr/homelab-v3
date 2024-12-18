resource "tls_private_key" "private_key_pem" {
  algorithm = "RSA"
}

resource "tls_cert_request" "certificate" {
  private_key_pem = tls_private_key.private_key_pem.private_key_pem

  subject {
    common_name  = var.namespace
    organization = var.namespace
  }
}

resource "cloudflare_origin_ca_certificate" "certificate" {
  csr                = tls_cert_request.certificate.cert_request_pem
  hostnames          = [cloudflare_record.reverse_proxy_root.hostname, cloudflare_record.reverse_proxy_subdomains.hostname]
  request_type       = "origin-rsa"
  requested_validity = 5475
}
