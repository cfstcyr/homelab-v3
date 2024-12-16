# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

# Homepage

variable "homepage_app" {
  description = "The name of the Homepage application"
  type        = string
  default     = "homepage"
}

# Routing

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
}

variable "homepage_subdomain" {
  type        = string
  description = "Domain for Homepage"
}