# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

# Home Assistant

variable "home_assistant_app" {
  description = "The name of the Home Assistant application"
  type        = string
  default     = "home-assistant"
}

# Routing

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
}

variable "reverse_proxy_ip" {
  type        = string
  description = "IP address of the reverse proxy"
}

variable "home_assistant_subdomain" {
  type        = string
  description = "Domain for Home Assistant"
}
