locals {
  admin_access_emails  = [for email in var.cloudflare_admin_access : email if can(regex("^[^@]", email))]
  admin_access_domains = [for email in var.cloudflare_admin_access : email if can(regex("^@", email))]
}

resource "cloudflare_zero_trust_access_group" "reverse_proxy_admin" {
  account_id = var.cloudflare_account_id
  name       = "${var.namespace}-reverse-proxy-admin"

  include {
    email        = local.admin_access_emails
    email_domain = local.admin_access_domains
  }
}

# Creates an Access application to control who can connect.
resource "cloudflare_zero_trust_access_application" "reverse_proxy_admin" {
  zone_id          = var.cloudflare_zone_id
  name             = "${var.namespace}-reverse-proxy-admin"
  domain           = cloudflare_record.reverse_proxy_root.hostname
  session_duration = "744h"
  type             = "self_hosted"

  destinations {
    uri = cloudflare_record.reverse_proxy_root.hostname
  }

  destinations {
    uri = cloudflare_record.reverse_proxy_subdomains.hostname
  }
}

# Creates an Access policy for the application.
resource "cloudflare_zero_trust_access_policy" "reverse_proxy_admin" {
  application_id = cloudflare_zero_trust_access_application.reverse_proxy_admin.id
  zone_id        = var.cloudflare_zone_id
  name           = "${var.namespace}-reverse-proxy-admin"
  precedence     = "1"
  decision       = "allow"

  include {
    group = [cloudflare_zero_trust_access_group.reverse_proxy_admin.id]
  }
}