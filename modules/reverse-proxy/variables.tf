# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
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