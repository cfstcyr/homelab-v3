locals {
  config_content = templatefile(
    "${var.config_path}/${var.home_assistant_app}/${local.config_file}",
    {
      base_url = "${var.home_assistant_subdomain}.${var.reverse_proxy_domains[0]}",
    },
  )
  config_content_hash = sha1(local.config_content)
}

resource "kubernetes_config_map" "home_assistant_config" {
  metadata {
    name      = var.home_assistant_app
    namespace = var.namespace
  }
  data = {
    "${local.config_file}" = local.config_content
  }
}
