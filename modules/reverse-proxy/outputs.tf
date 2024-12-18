output "reverse_proxy_hostname" {
  value = kubernetes_service.traefik_http.metadata[0].name
}