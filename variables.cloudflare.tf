variable "cloudflare_api_token" {
  description = "API token for Cloudflare"
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
  nullable    = true
  default     = null
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "cloudflare_access_team" {
  description = "Team name for Cloudflare Access"
  type        = string
  nullable    = true
  default     = null
}

# Admin access

variable "cloudflare_admin_access" {
  description = "List of emails or email domains that should have admin access to everything"
  type        = list(string)
  nullable    = true
  default     = null
}

locals {
  cloudflare_variables_all_set = (
    var.cloudflare_api_token != null
    && var.cloudflare_zone_id != null
    && var.cloudflare_account_id != null
    && var.cloudflare_access_team != null
    && var.cloudflare_admin_access != null
  )
  cloudflare_variables_none_set = (
    var.cloudflare_api_token == null
    && var.cloudflare_zone_id == null
    && var.cloudflare_account_id == null
    && var.cloudflare_access_team == null
    && var.cloudflare_admin_access == null
  )
}

resource "terraform_data" "validate_cloudflare_variables" {
  lifecycle {
    precondition {
      condition = (
        local.cloudflare_variables_all_set
        || local.cloudflare_variables_none_set
      )
      error_message = "Either all or none of the Cloudflare variables must be set"
    }
  }
}