output "cron_job_name" {
  value = kubernetes_cron_job_v1.buildarr.metadata[0].name
}

output "config_hash" {
  value = local.buildarr_config_hash
}