locals {
  config_path = "${var.config_path}/${local.traefik}"

  traefik_config_file = "traefik.yml"
  traefik_config_providers_dir = "providers"

  traefik_config_content = templatefile(
    "${local.config_path}/${local.traefik_config_file}",
    { test = "hello" }
  )

  traefik_config_providers_content = {
    for file in fileset("${local.config_path}/${local.traefik_config_providers_dir}", "*") : file => templatefile(
      "${local.config_path}/${local.traefik_config_providers_dir}/${file}",
      { hostname = "hello" }
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
    name = "${local.traefik}-config"
    namespace = var.namespace
  }

  data = {
    (local.traefik_config_file) = local.traefik_config_content
  }
}

resource "kubernetes_config_map" "traefik_config_providers" {
  metadata {
    name = "${local.traefik}-config-providers"
    namespace = var.namespace
  }

  data = local.traefik_config_providers_content
}
