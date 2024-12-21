# 2024-12-21 13:01:25 Error from server (Forbidden): cronjobs.batch "buildarr-radarr" is forbidden: User "system:serviceaccount:homelab-v3:default" cannot get resource "cronjobs" in API group "batch" in the namespace "homelab-v3"


resource "kubernetes_service_account" "media_management" {
  metadata {
    name      = var.media_management_app
    namespace = var.namespace
  }
}

resource "kubernetes_role" "media_management" {
  metadata {
    name      = var.media_management_app
    namespace = var.namespace
  }

  rule {
    api_groups = ["batch"]
    resources  = ["cronjobs"]
    verbs      = ["get", "list", "watch"]
  }

  rule {
    api_groups = ["batch"]
    resources  = ["jobs"]
    verbs      = ["create"]
  }
}

resource "kubernetes_role_binding" "media_management" {
  metadata {
    name      = var.media_management_app
    namespace = var.namespace
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.media_management.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.media_management.metadata[0].name
    namespace = var.namespace
  }
}