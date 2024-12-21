locals {
  buildarr_args = ["--log-level", "DEBUG", "run", "/config/${var.target_config_file_name}"]
}

resource "kubernetes_cron_job_v1" "buildarr" {
  metadata {
    name      = "${var.buildarr_app}-${var.target_app}"
    namespace = var.namespace
  }

  spec {
    schedule = "0 3,9,15,21 * * *"

    job_template {
      metadata {}

      spec {
        ttl_seconds_after_finished = 100

        template {
          metadata {
            annotations = {
              "buildarr_config_hash" = local.buildarr_config_hash
            }
          }

          spec {
            volume {
              name = "${var.buildarr_app}-${var.target_app}-config"

              config_map {
                name = kubernetes_config_map.buildarr_config.metadata[0].name
              }
            }

            container {
              name  = "${var.buildarr_app}-${var.target_app}"
              image = "callum027/buildarr:latest"

              args = local.buildarr_args

              volume_mount {
                name       = "${var.buildarr_app}-${var.target_app}-config"
                mount_path = "/config"
                read_only  = true
              }
            }
          }
        }
      }
    }
  }
}
