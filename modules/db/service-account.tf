resource "kubernetes_service_account" "postgres" {
  metadata {
    name = var.postgres_app
    namespace = var.namespace
  }
}

resource "kubernetes_role" "postgres" {
  metadata {
    name = "${var.postgres_app}-role"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["configmaps", "secrets", "persistentvolumeclaims"]
    verbs      = ["get", "list", "create", "update", "delete"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_role_binding" "postgres" {
  metadata {
    name = "${var.postgres_app}-role-binding"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = kubernetes_role.postgres.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.postgres.metadata[0].name
    namespace = "postgres"
  }
}