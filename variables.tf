variable "certificates_email" {
  type        = string
  description = "Email address to use for Let's Encrypt certificates. This is required for the HTTPS setup for the reverse proxy."
}

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab. These will be used for the reverse proxy configuration. Only the domains specified here will be allowed to access the homelab. If you specify multiple domains, only the first will be used for the Homepage URLs. This will NOT be used for the Cloudflare Tunnel configuration."
  default     = ["localhost"]

  validation {
    condition     = length(var.reverse_proxy_domains) > 0
    error_message = "At least one domain must be specified"
  }
}

variable "public_endpoints" {
  type        = list(string)
  description = "Public endpoints for the homelab. When accessing the app through the Cloudflare Tunnel, these endpoints will not require authentication."
  default     = []
}

variable "vpn_env" {
  type        = map(string)
  description = "Environment variables for the VPN container. See the Gluetun documentation for more information: https://github.com/qdm12/gluetun-wiki/tree/main/setup#setup"
  sensitive   = true
}