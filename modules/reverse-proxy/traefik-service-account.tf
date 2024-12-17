resource "kubernetes_service_account" "traefik" {
  metadata {
    name      = "${var.traefik_app}-service-account"
    namespace = var.namespace
  }
}

resource "kubernetes_role" "traefik-ingress" {
  metadata {
    name      = "${var.traefik_app}-ingress-controller"
    namespace = var.namespace
  }

  # Define the necessary permissions for Ingress resources
  rule {
    api_groups = ["", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["list", "get", "watch", "create", "update", "delete"]
  }

  # You also need access to other resources like services (for backend communication)
  rule {
    api_groups = [""]
    resources  = ["services", "configmaps"]
    verbs      = ["list", "get"]
  }
}

resource "kubernetes_role_binding" "traefik" {
  metadata {
    name      = "${var.traefik_app}-ingress-controller"
    namespace = var.namespace
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.traefik.metadata[0].name
    namespace = kubernetes_service_account.traefik.metadata[0].namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_role.traefik-ingress.metadata[0].name
  }
}

// TODO: Find actual permissions for Traefik instead of using cluster-admin
resource "kubernetes_cluster_role_binding" "traefik-admin" {
  metadata {
    name = "${var.traefik_app}-ingress-controller-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.traefik.metadata[0].name
    namespace = kubernetes_service_account.traefik.metadata[0].namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
}
