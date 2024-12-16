#############################
# GLOBAL
#############################

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
  default     = [ "localhost" ]
}

#############################
# APPS
#############################

# Traefik  ==================

variable "traefik_subdomain" {
  type        = string
  description = "Domain for Traefik"
  nullable = true
  default     = "traefik"
}

# Homepage  =================

variable "homepage_subdomain" {
  type        = string
  description = "Domain for homepage"
  nullable    = true
  default     = null
}