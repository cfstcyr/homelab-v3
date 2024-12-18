# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

variable "certificates_email" {
  type        = string
  description = "Email address to use for Let's Encrypt certificates"
}

variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
  nullable    = true
}

# Traefik

variable "traefik_app" {
  description = "The name of the Traefik application"
  type        = string
  default     = "traefik"
}

# Routing

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
}

variable "traefik_subdomain" {
  type        = string
  description = "Domain for Traefik"
}