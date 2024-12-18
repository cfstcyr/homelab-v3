resource "kubernetes_persistent_volume_claim" "acme" {
  metadata {
    name      = "acme"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Mi"
      }
    }
  }
}