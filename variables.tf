variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
  default     = ["localhost"]
}

variable "vpn_env" {
  type        = map(string)
  description = "Environment variables for the VPN container. See the Gluetun documentation for more information: https://github.com/qdm12/gluetun-wiki/tree/main/setup#setup"
  sensitive   = true
}