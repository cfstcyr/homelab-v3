# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

variable "vpn_env" {
  type        = map(string)
  description = "Environment variables for the VPN container. See the Gluetun documentation for more information: https://github.com/qdm12/gluetun-wiki/tree/main/setup#setup"
  sensitive   = true
}

# Apps

variable "media_management_app" {
  description = "The name of the Media Management applications"
  type        = string
  default     = "media-management"
}

# Routing

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
}

variable "radarr_subdomain" {
  type        = string
  description = "Domain for Radarr"
}

variable "sonarr_subdomain" {
  type        = string
  description = "Domain for Homepage"
}

variable "transmission_subdomain" {
  type        = string
  description = "Domain for Transmission"
}

variable "prowlarr_subdomain" {
  type        = string
  description = "Domain for Prowlarr"
}

variable "overseerr_subdomain" {
  type        = string
  description = "Domain for Overseerr"
}

variable "overseerr_api_key" {
  type        = string
  description = "Overseerr API Key"
}

# Paths

variable "library_movies_dir" {
  type        = string
  description = "Path to the movies library"
}

variable "library_tv_dir" {
  type        = string
  description = "Path to the TV shows library"
}

variable "downloads_dir" {
  type        = string
  description = "Path to the downloads directory"
}