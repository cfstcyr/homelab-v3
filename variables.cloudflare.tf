variable "cloudflare_api_token" {
  description = "API token for Cloudflare. See https://developers.cloudflare.com/fundamentals/api/get-started/create-token/ for more information."
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain. See https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/ for more information."
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account. See https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/ for more information."
  type        = string
  sensitive   = true
}

variable "cloudflare_access_team" {
  description = "Team name for Cloudflare Access. This is the team name used in the Cloudflare Access domain: `TEAM_NAME.cloudflareaccess.com`. Go to Cloudflare Zero Trust > Settings > Custom Pages to find this."
  type        = string
}

# Admin access

variable "cloudflare_admin_access" {
  description = "List of emails or email domains that should have admin access to everything. Only the emails and email domains will be able to request a code to access the apps through Cloudflare Access."
  type        = list(string)
}
