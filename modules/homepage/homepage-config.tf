locals {
  config_path = "${var.config_path}/${var.homepage_app}"

  config_content = {
    for file in fileset("${local.config_path}", "*") : file => templatefile(
      "${local.config_path}/${file}",
      { instanceName: "${var.namespace}-${var.homepage_app}" }
    )
  }

  config_hash = sha1(join(
    "",
    [for content in local.config_content : content]
  ))
}

resource "kubernetes_config_map" "homepage_config" {
  metadata {
    name = "${var.homepage_app}-config"
    namespace = var.namespace
  }

  data = local.config_content
}