# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

# Pi-hole

variable "pi_hole_app" {
  description = "The name of the Pi-hole application"
  type        = string
  default     = "pi-hole"
}

# Routing

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
}

variable "pi_hole_subdomain" {
  type        = string
  description = "Domain for Pi-hole"
}

variable "pi_hole_api_key" {
  type        = string
  description = "API key for Pi-hole. This is required to display the widgets on the homepage. If null, the widgets will not be displayed."
  nullable    = true
}