resource "random_id" "radarr_api_key" {
  byte_length = 16
}

resource "random_id" "sonarr_api_key" {
  byte_length = 16
}

resource "random_id" "prowlarr_api_key" {
  byte_length = 16
}
