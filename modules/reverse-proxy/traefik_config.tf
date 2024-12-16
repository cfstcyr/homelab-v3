locals {
  config_path = "${var.config_path}/${local.traefik}"

  traefik_config_file = "traefik.yml"
  traefik_providers_dir = "providers"
}

resource "kubernetes_config_map" "traefik_config" {
  metadata {
    name = "${local.traefik}-config"
    namespace = var.namespace
  }

  data = {
    (local.traefik_config_file) = templatefile(
      "${local.config_path}/${local.traefik_config_file}",
      { test = "hello" }
    )
  }
}

resource "kubernetes_config_map" "traefik_config_providers" {
  metadata {
    name = "${local.traefik}-config-providers"
    namespace = var.namespace
  }

  data = {
    for file in fileset("${local.config_path}/${local.traefik_providers_dir}", "*") : file => templatefile(
      "${local.config_path}/${local.traefik_providers_dir}/${file}",
      { hostname = "hello" }
    )
  }
}