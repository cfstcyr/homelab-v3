variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
}

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

# Admin access

variable "cloudflare_admin_access" {
  description = "List of emails or email domains that should have admin access to everything"
  type        = list(string)

  validation {
    condition     = length(var.cloudflare_admin_access) > 0
    error_message = "At least one email or email domain must be provided"
  }

  validation {
    condition     = alltrue([for email in var.cloudflare_admin_access : can(regex("^([a-zA-Z0-9._%+-]+)?@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))])
    error_message = "All emails or email domains must be valid"
  }
}