resource "random_password" "postgres_password" {
  length  = 32
  special = true
}

resource "kubernetes_secret" "postgres_auth" {
  metadata {
    name      = "${var.postgres_app}-auth"
    namespace = var.namespace
  }

  data = {
    username = var.postgres_username
    password = random_password.postgres_password.result
  }
}
