locals {
  content = {
    for file in fileset(var.dir, var.glob) : file => templatefile(
      "${var.dir}/${file}",
      var.template_vars
    )
  }

  hash = sha1(join(
    "",
    [for content in local.content : content]
  ))
}

resource "kubernetes_config_map" "config" {
  metadata {
    name = var.name
    namespace = var.namespace
  }

  data = local.content
}

output "hash" {
  value = local.hash
}

output "config_map" {
  value = kubernetes_config_map.config.metadata.0.name
}