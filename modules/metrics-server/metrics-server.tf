resource "helm_release" "metrics_server" {
  name       = "metrics-server"
  namespace  = var.namespace
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "~> 3.11.0"

  set {
    name  = "args[0]"
    value = "--kubelet-insecure-tls"
  }
}