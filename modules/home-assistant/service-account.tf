resource "kubernetes_service_account" "home_assistant_sa" {
  metadata {
    name      = "${var.home_assistant_app}-sa"
    namespace = var.namespace
  }
}

resource "kubernetes_role" "home_assistant_role" {
  metadata {
    name      = "${var.home_assistant_app}-role"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "configmaps"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_role_binding" "home_assistant_binding" {
  metadata {
    name      = "${var.home_assistant_app}-rolebinding"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.home_assistant_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.home_assistant_sa.metadata[0].name
    namespace = var.namespace
  }
}
