locals {
  buildarr_config_data = {
    "buildarr.yml" = templatefile("${var.config_path}/${local.buildarr_app}/buildarr.yml", {})
    "radarr.yml" = templatefile(
      "${var.config_path}/${local.buildarr_app}/radarr.yml",
      { radarr_api_key = random_id.radarr_api_key.hex },
    )
    "sonarr.yml" = templatefile(
      "${var.config_path}/${local.buildarr_app}/sonarr.yml",
      { sonarr_api_key = random_id.sonarr_api_key.hex },
    )
    "prowlarr.yml" = templatefile(
      "${var.config_path}/${local.buildarr_app}/prowlarr.yml",
      { prowlarr_api_key = random_id.prowlarr_api_key.hex },
    )
  }

  buildarr_config_hash = sha1(jsonencode(local.buildarr_config_data))
}

resource "kubernetes_config_map" "buildarr_config" {
  metadata {
    name      = "${local.buildarr_app}-config"
    namespace = var.namespace
  }

  data = local.buildarr_config_data
}