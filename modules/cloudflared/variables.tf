# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

# Cloudflared

variable "cloudflared_app" {
  description = "The name of the Cloudflared application"
  type        = string
  default     = "cloudflared"
}

variable "cloudflare_tunnel_token" {
  description = "The Cloudflare Tunnel token"
  type        = string
  sensitive   = true
}
