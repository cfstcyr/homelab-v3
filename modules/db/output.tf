output "db_hostname" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "db_ip" {
  value = kubernetes_service.postgres.spec[0].cluster_ip
}

output "db_port" {
  value = kubernetes_service.postgres.spec[0].port[0].port
}

output "db_auth_secret" {
  value = kubernetes_secret.postgres_auth.metadata[0].name
}