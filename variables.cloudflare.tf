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
}
