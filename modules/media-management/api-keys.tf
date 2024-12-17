resource "random_string" "radarr_api_key" {
  length  = 32
  special = false
}

resource "random_string" "sonarr_api_key" {
  length  = 32
  special = false
}

resource "random_string" "prowlarr_api_key" {
  length  = 32
  special = false
}
