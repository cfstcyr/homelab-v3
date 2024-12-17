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

# Radarr  ===================

variable "radarr_subdomain" {
  type        = string
  description = "Domain for Radarr"
  nullable    = true
  default     = "radarr"
}

variable "radarr_api_key" {
  type        = string
  description = "API key for Radarr"
  nullable    = true
  sensitive   = true
  default     = null
}

# Sonarr  ===================

variable "sonarr_subdomain" {
  type        = string
  description = "Domain for Sonarr"
  nullable    = true
  default     = "sonarr"
}

variable "sonarr_api_key" {
  type        = string
  description = "API key for Sonarr"
  nullable    = true
  sensitive   = true
  default     = null
}

# Prowlarr  =================

variable "prowlarr_subdomain" {
  type        = string
  description = "Domain for Prowlarr"
  nullable    = true
  default     = "prowlarr"
}

variable "prowlarr_api_key" {
  type        = string
  description = "API key for Prowlarr"
  nullable    = true
  sensitive   = true
  default     = null
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