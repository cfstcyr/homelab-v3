locals {
  buildarr_config_path = "${var.config_path}/${var.buildarr_app}"

  buildarr_config_data = {
    (var.target_config_file_name) = templatefile(
      "${local.buildarr_config_path}/${var.target_config_file_name}",
      merge({
        "${var.target_config_prefix}hostname" = var.target_hostname,
        "${var.target_config_prefix}port"     = var.target_port,
        "${var.target_config_prefix}api_key"  = var.target_api_key,
      }, var.target_config_extra),
    )
  }

  buildarr_config_hash = sha1(jsonencode(local.buildarr_config_data))
}

resource "kubernetes_config_map" "buildarr_config" {
  metadata {
    name      = "${var.buildarr_app}-${var.target_app}-config"
    namespace = var.namespace
  }

  data = local.buildarr_config_data
}