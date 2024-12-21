module "buildarr_radarr" {
  source = "./buildarr"

  namespace   = var.namespace
  config_path = var.config_path

  buildarr_app = local.buildarr_app

  target_app              = local.radarr_app
  target_config_file_name = "${local.radarr_app}.yml"
  target_config_prefix    = "${local.radarr_app}_"
  target_hostname         = kubernetes_service.radarr.metadata[0].name
  target_port             = kubernetes_service.radarr.spec[0].port[0].port
  target_api_key          = random_id.radarr_api_key.hex
}

module "buildarr_sonarr" {
  source = "./buildarr"

  namespace   = var.namespace
  config_path = var.config_path

  buildarr_app = local.buildarr_app

  target_app              = local.sonarr_app
  target_config_file_name = "${local.sonarr_app}.yml"
  target_config_prefix    = "${local.sonarr_app}_"
  target_hostname         = kubernetes_service.sonarr.metadata[0].name
  target_port             = kubernetes_service.sonarr.spec[0].port[0].port
  target_api_key          = random_id.sonarr_api_key.hex
}

module "buildarr_prowlarr" {
  source = "./buildarr"

  namespace   = var.namespace
  config_path = var.config_path

  buildarr_app = local.buildarr_app

  target_app              = local.prowlarr_app
  target_config_file_name = "${local.prowlarr_app}.yml"
  target_config_prefix    = "${local.prowlarr_app}_"
  target_config_extra = {
    "sonarr_api_key" = random_id.sonarr_api_key.hex
    "radarr_api_key" = random_id.radarr_api_key.hex
  }
  target_hostname = kubernetes_service.prowlarr.metadata[0].name
  target_port     = kubernetes_service.prowlarr.spec[0].port[0].port
  target_api_key  = random_id.prowlarr_api_key.hex
}