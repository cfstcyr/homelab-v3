locals {
  config_path = "${var.config_path}/${var.traefik_app}"

  traefik_config_file = "traefik.yml"
  traefik_config_providers_dir = "providers"

  traefik_config_content = templatefile(
    "${local.config_path}/${local.traefik_config_file}",
    {
      namespace = var.namespace
    }
  )

  traefik_config_providers_content = {
    for file in fileset("${local.config_path}/${local.traefik_config_providers_dir}", "*") : file => templatefile(
      "${local.config_path}/${local.traefik_config_providers_dir}/${file}",
      {}
    )
  }

  traefik_config_hash = sha1(local.traefik_config_content)
  traefik_config_providers_hash = sha1(join(
    "",
    [for content in local.traefik_config_providers_content : content]
  ))
}

resource "kubernetes_config_map" "traefik_config" {
  metadata {
    name = "${var.traefik_app}-config"
    namespace = var.namespace
  }

  data = {
    (local.traefik_config_file) = local.traefik_config_content
  }
}

resource "kubernetes_config_map" "traefik_config_providers" {
  metadata {
    name = "${var.traefik_app}-config-providers"
    namespace = var.namespace
  }

  data = local.traefik_config_providers_content
}
