# Traefik  ==================

variable "traefik_subdomain" {
  type        = string
  description = "Domain for Traefik"
  nullable    = true
  default     = "traefik"
}

# Homepage  =================

variable "homepage_subdomain" {
  type        = string
  description = "Domain for homepage"
  nullable    = true
  default     = null
}

# Radarr  ===================

variable "radarr_subdomain" {
  type        = string
  description = "Domain for Radarr"
  nullable    = true
  default     = "radarr"
}

# Sonarr  ===================

variable "sonarr_subdomain" {
  type        = string
  description = "Domain for Sonarr"
  nullable    = true
  default     = "sonarr"
}

# Prowlarr  =================

variable "prowlarr_subdomain" {
  type        = string
  description = "Domain for Prowlarr"
  nullable    = true
  default     = "prowlarr"
}

# Transmission  =============

variable "transmission_subdomain" {
  type        = string
  description = "Domain for Transmission"
  nullable    = true
  default     = "transmission"
}

# Overseerr  =================

variable "overseerr_subdomain" {
  type        = string
  description = "Domain for Overseerr"
  nullable    = true
  default     = "overseerr"
}

variable "overseerr_api_key" {
  type        = string
  description = "Overseerr API Key"
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
