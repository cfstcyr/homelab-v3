resource "kubernetes_namespace" "homelab" {
  metadata {
    name = "homelab-v3"
  }
}