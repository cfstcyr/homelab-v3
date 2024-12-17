module "traefik_config" {
  source = "../utils/dir_map_config"

  name      = "${var.traefik_app}-config"
  namespace = var.namespace

  dir  = "${var.config_path}/${var.traefik_app}"
  glob = "traefik.yml"

  template_vars = {
    namespace = var.namespace
  }
}

module "traefik_config_providers" {
  source = "../utils/dir_map_config"

  name      = "${var.traefik_app}-config-providers"
  namespace = var.namespace

  dir = "${var.config_path}/${var.traefik_app}/providers"

  template_vars = {}
}