# Terraform

This is the Terraform configuration documentation. Refer to the [README](../README.md) for more information about the project.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.10.2 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.40 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 2.16 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.33.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.33.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloudflare"></a> [cloudflare](#module\_cloudflare) | ./modules/cloudflare | n/a |
| <a name="module_cloudflared"></a> [cloudflared](#module\_cloudflared) | ./modules/cloudflared | n/a |
| <a name="module_homepage"></a> [homepage](#module\_homepage) | ./modules/homepage | n/a |
| <a name="module_media_management"></a> [media\_management](#module\_media\_management) | ./modules/media-management | n/a |
| <a name="module_metrics_server"></a> [metrics\_server](#module\_metrics\_server) | ./modules/metrics-server | n/a |
| <a name="module_reverse-proxy"></a> [reverse-proxy](#module\_reverse-proxy) | ./modules/reverse-proxy | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.homelab](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_certificates_email"></a> [certificates\_email](#input\_certificates\_email) | Email address to use for Let's Encrypt certificates. This is required for the HTTPS setup for the reverse proxy. | `string` | n/a | yes |
| <a name="input_cloudflare_access_team"></a> [cloudflare\_access\_team](#input\_cloudflare\_access\_team) | Team name for Cloudflare Access. This is the team name used in the Cloudflare Access domain: `TEAM_NAME.cloudflareaccess.com`. Go to Cloudflare Zero Trust > Settings > Custom Pages to find this. | `string` | n/a | yes |
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | Account ID for your Cloudflare account. See https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/ for more information. | `string` | n/a | yes |
| <a name="input_cloudflare_admin_access"></a> [cloudflare\_admin\_access](#input\_cloudflare\_admin\_access) | List of emails or email domains that should have admin access to everything. Only the emails and email domains will be able to request a code to access the apps through Cloudflare Access. | `list(string)` | n/a | yes |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | API token for Cloudflare. See https://developers.cloudflare.com/fundamentals/api/get-started/create-token/ for more information. | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Zone ID for your domain. See https://developers.cloudflare.com/fundamentals/setup/find-account-and-zone-ids/ for more information. | `string` | n/a | yes |
| <a name="input_downloads_dir"></a> [downloads\_dir](#input\_downloads\_dir) | Path on the host pointing to the downloads directory. This is where Transmission will download the torrents to. It is also where Radarr and Sonarr will read the files from after downloading. | `string` | n/a | yes |
| <a name="input_homepage_subdomain"></a> [homepage\_subdomain](#input\_homepage\_subdomain) | Domain for Homepage. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `null` | no |
| <a name="input_library_movies_dir"></a> [library\_movies\_dir](#input\_library\_movies\_dir) | Path on the host pointing to the movies library. This is the directory where Radarr will store the movies and where Plex will read them from. | `string` | n/a | yes |
| <a name="input_library_tv_dir"></a> [library\_tv\_dir](#input\_library\_tv\_dir) | Path on the host pointing to the TV shows library. This is the directory where Sonarr will store the TV shows and where Plex will read them from. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Used to group resources in kubernetes. This will also be used as prefix for other resources | `string` | `"homelab-v3"` | no |
| <a name="input_overseerr_api_key"></a> [overseerr\_api\_key](#input\_overseerr\_api\_key) | API key for Overseerr. This is required to display the widgets on the homepage. If null, the widgets will not be displayed. | `string` | `null` | no |
| <a name="input_overseerr_subdomain"></a> [overseerr\_subdomain](#input\_overseerr\_subdomain) | Domain for Overseerr. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `"overseerr"` | no |
| <a name="input_prowlarr_subdomain"></a> [prowlarr\_subdomain](#input\_prowlarr\_subdomain) | Domain for Prowlarr. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `"prowlarr"` | no |
| <a name="input_public_endpoints"></a> [public\_endpoints](#input\_public\_endpoints) | Public endpoints for the homelab. When accessing the app through the Cloudflare Tunnel, these endpoints will not require authentication. | `list(string)` | `[]` | no |
| <a name="input_radarr_subdomain"></a> [radarr\_subdomain](#input\_radarr\_subdomain) | Domain for Radarr. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `"radarr"` | no |
| <a name="input_reverse_proxy_domains"></a> [reverse\_proxy\_domains](#input\_reverse\_proxy\_domains) | Domains for the homelab. These will be used for the reverse proxy configuration. Only the domains specified here will be allowed to access the homelab. If you specify multiple domains, only the first will be used for the Homepage URLs. This will NOT be used for the Cloudflare Tunnel configuration. | `list(string)` | <pre>[<br/>  "localhost"<br/>]</pre> | no |
| <a name="input_sonarr_subdomain"></a> [sonarr\_subdomain](#input\_sonarr\_subdomain) | Domain for Sonarr. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `"sonarr"` | no |
| <a name="input_traefik_subdomain"></a> [traefik\_subdomain](#input\_traefik\_subdomain) | Domain to access Traefik Dashboard. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `"traefik"` | no |
| <a name="input_transmission_subdomain"></a> [transmission\_subdomain](#input\_transmission\_subdomain) | Domain for Transmission. This will be concatenated with the domains from reverse\_proxy\_domains. | `string` | `"transmission"` | no |
| <a name="input_vpn_env"></a> [vpn\_env](#input\_vpn\_env) | Environment variables for the VPN container. See the Gluetun documentation for more information: https://github.com/qdm12/gluetun-wiki/tree/main/setup#setup | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->