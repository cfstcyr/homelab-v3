module "homepage_config" {
  source = "../utils/dir_map_config"

  name = "${var.homepage_app}-config"
  namespace = var.namespace

  dir = "${var.config_path}/${var.homepage_app}"
  
  template_vars = {
    instanceName = "${var.namespace}-${var.homepage_app}"
  }
}