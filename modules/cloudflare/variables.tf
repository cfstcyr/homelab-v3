# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "reverse_proxy_hostname" {
  description = "The hostname of the reverse proxy"
  type        = string
}

variable "public_endpoints" {
  type        = list(string)
  description = "Public endpoints for the homelab"
}

# Cloudflare

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_access_team" {
  description = "Team name for Cloudflare Access"
  type        = string
}

# Access

variable "cloudflare_admin_access" {
  description = "List of emails or email domains that should have admin access to everything"
  type        = list(string)

  validation {
    condition     = length(var.cloudflare_admin_access) > 0
    error_message = "At least one email or email domain must be provided"
  }

  validation {
    condition     = alltrue([for email in var.cloudflare_admin_access : can(regex("(^[a-zA-Z0-9._%+-]+)?@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))])
    error_message = "All emails or email domains must be valid"
  }
}