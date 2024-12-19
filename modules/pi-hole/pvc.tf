resource "kubernetes_persistent_volume_claim" "pi_hole_config" {
  metadata {
    name      = "${var.pi_hole_app}-config"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "200Mi"
      }
    }
  }
}