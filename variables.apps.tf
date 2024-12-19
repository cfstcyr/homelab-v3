# Traefik  ==================

variable "traefik_subdomain" {
  type        = string
  description = "Domain to access Traefik Dashboard. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = "traefik"
}

# Homepage  =================

variable "homepage_subdomain" {
  type        = string
  description = "Domain for Homepage. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = null
}

# Radarr  ===================

variable "radarr_subdomain" {
  type        = string
  description = "Domain for Radarr. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = "radarr"
}

# Sonarr  ===================

variable "sonarr_subdomain" {
  type        = string
  description = "Domain for Sonarr. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = "sonarr"
}

# Prowlarr  =================

variable "prowlarr_subdomain" {
  type        = string
  description = "Domain for Prowlarr. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = "prowlarr"
}

# Transmission  =============

variable "transmission_subdomain" {
  type        = string
  description = "Domain for Transmission. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = "transmission"
}

# Overseerr  =================

variable "overseerr_subdomain" {
  type        = string
  description = "Domain for Overseerr. This will be concatenated with the domains from reverse_proxy_domains."
  nullable    = true
  default     = "overseerr"
}

variable "overseerr_api_key" {
  type        = string
  description = "API key for Overseerr. This is required to display the widgets on the homepage. If null, the widgets will not be displayed."
  nullable    = true
  default     = null
}

# Pi-Hole ==================

# variable "pi_hole_subdomain" {
#   type        = string
#   description = "Domain for Pi-hole"
#   nullable    = true
#   default     = "pihole"
# }
