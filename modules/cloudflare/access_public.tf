resource "cloudflare_zero_trust_access_application" "reverse_proxy_public" {
  count = length(var.public_endpoints) > 0 ? 1 : 0

  zone_id          = var.cloudflare_zone_id
  name             = "${var.namespace}-reverse-proxy-public"
  domain           = var.public_endpoints[0]
  session_duration = "24h"

  dynamic "destinations" {
    for_each = var.public_endpoints
    content {
      uri = destinations.value
    }
  }
}

resource "cloudflare_zero_trust_access_policy" "reverse_proxy_public" {
  count = length(var.public_endpoints) > 0 ? 1 : 0

  application_id = cloudflare_zero_trust_access_application.reverse_proxy_public[0].id
  zone_id        = var.cloudflare_zone_id
  name           = "${var.namespace}-reverse-proxy-public"
  precedence     = "1"
  decision       = "non_identity"

  include {
    everyone = true
  }
}