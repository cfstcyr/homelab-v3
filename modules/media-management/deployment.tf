resource "kubernetes_deployment" "media_management" {
  metadata {
    name      = var.media_management_app
    namespace = var.namespace

    labels = {
      app = var.media_management_app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.media_management_app
      }
    }

    template {
      metadata {
        labels = {
          app = var.media_management_app
        }
      }

      spec {
        service_account_name = kubernetes_service_account.media_management.metadata[0].name

        volume {
          name = "tun-device"
          host_path {
            path = "/dev/net/tun"
            type = "CharDevice"
          }
        }

        volume {
          name = "movies"
          host_path {
            path = var.library_movies_dir
            type = "Directory"
          }
        }

        volume {
          name = "tv"
          host_path {
            path = var.library_tv_dir
            type = "Directory"
          }
        }

        volume {
          name = "downloads"
          host_path {
            path = var.downloads_dir
            type = "Directory"
          }
        }

        volume {
          name = "${local.sonarr_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.sonarr_config.metadata[0].name
          }
        }

        volume {
          name = "${local.radarr_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.radarr_config.metadata[0].name
          }
        }

        volume {
          name = "${local.prowlarr_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.prowlarr_config.metadata[0].name
          }
        }

        volume {
          name = "${local.transmission_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.transmission_config.metadata[0].name
          }
        }

        container {
          name  = local.vpn_app
          image = "qmcgaw/gluetun:v3.37.0"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          volume_mount {
            name       = "tun-device"
            mount_path = "/dev/net/tun"
          }

          port {
            container_port = 8000
          }

          dynamic "env" {
            for_each = var.vpn_env

            content {
              name  = env.key
              value = env.value
            }
          }
        }

        container {
          name  = local.sonarr_app
          image = "linuxserver/sonarr:latest"

          port {
            container_port = 8989
          }

          volume_mount {
            name       = "tv"
            mount_path = "/tv"
          }

          volume_mount {
            name       = "${local.sonarr_app}-config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "downloads"
            mount_path = "/downloads"
          }

          env {
            name  = "BUILDARR_SONARR_CONFIG_HASH"
            value = module.buildarr_sonarr.config_hash
          }
        }

        container {
          name  = local.radarr_app
          image = "linuxserver/radarr:latest"

          port {
            container_port = 7878
          }

          volume_mount {
            name       = "movies"
            mount_path = "/movies"
          }

          volume_mount {
            name       = "${local.radarr_app}-config"
            mount_path = "/config"
          }

          volume_mount {
            name       = "downloads"
            mount_path = "/downloads"
          }

          env {
            name  = "BUILDARR_RADARR_CONFIG_HASH"
            value = module.buildarr_radarr.config_hash
          }
        }

        container {
          name  = local.prowlarr_app
          image = "lscr.io/linuxserver/prowlarr:latest"

          port {
            container_port = 9696
          }

          volume_mount {
            name       = "${local.prowlarr_app}-config"
            mount_path = "/config"
          }

          env {
            name  = "BUILDARR_PROWLARR_CONFIG_HASH"
            value = module.buildarr_prowlarr.config_hash
          }
        }

        container {
          name  = local.transmission_app
          image = "linuxserver/transmission:latest"

          port {
            container_port = 9091
          }

          volume_mount {
            name       = "downloads"
            mount_path = "/downloads"
          }

          volume_mount {
            name       = "${local.transmission_app}-config"
            mount_path = "/config"
          }
        }

        init_container {
          name    = "${local.radarr_app}-init"
          image   = "bitnami/kubectl:latest"
          command = ["/bin/sh", "-c"]
          args = [templatefile(
            "${var.config_path}/scripts/init-arr.sh",
            {
              config_file = "/config/config.xml",
              api_key     = random_id.radarr_api_key.hex,
            },
          )]

          volume_mount {
            name       = "${local.radarr_app}-config"
            mount_path = "/config"
          }
        }

        init_container {
          name    = "${local.sonarr_app}-init"
          image   = "bitnami/kubectl:latest"
          command = ["/bin/sh", "-c"]
          args = [templatefile(
            "${var.config_path}/scripts/init-arr.sh",
            {
              config_file = "/config/config.xml",
              api_key     = random_id.sonarr_api_key.hex,
            },
          )]

          volume_mount {
            name       = "${local.sonarr_app}-config"
            mount_path = "/config"
          }
        }

        init_container {
          name    = "${local.prowlarr_app}-init"
          image   = "bitnami/kubectl:latest"
          command = ["/bin/sh", "-c"]
          args = [templatefile(
            "${var.config_path}/scripts/init-arr.sh",
            {
              config_file = "/config/config.xml",
              api_key     = random_id.prowlarr_api_key.hex,
            },
          )]

          volume_mount {
            name       = "${local.prowlarr_app}-config"
            mount_path = "/config"
          }
        }

        init_container {
          name  = "${local.buildarr_app}-${local.radarr_app}-init"
          image = "bitnami/kubectl:latest"

          command = [
            "/bin/sh",
            "-c",
          "kubectl create job --from=cronjob/${module.buildarr_radarr.cron_job_name} ${module.buildarr_radarr.cron_job_name}-$(date +%s)"]
        }

        init_container {
          name  = "${local.buildarr_app}-${local.sonarr_app}-init"
          image = "bitnami/kubectl:latest"

          command = ["/bin/sh", "-c", "kubectl create job --from=cronjob/${module.buildarr_sonarr.cron_job_name} ${module.buildarr_sonarr.cron_job_name}-$(date +%s)"]
        }

        init_container {
          name  = "${local.buildarr_app}-${local.prowlarr_app}-init"
          image = "bitnami/kubectl:latest"

          command = ["/bin/sh", "-c", "kubectl create job --from=cronjob/${module.buildarr_prowlarr.cron_job_name} ${module.buildarr_prowlarr.cron_job_name}-$(date +%s)"]
        }
      }
    }
  }
}

resource "kubernetes_deployment" "overseerr" {
  metadata {
    name      = local.overseerr_app
    namespace = var.namespace

    labels = {
      app = local.overseerr_app
    }
  }

  spec {
    selector {
      match_labels = {
        app = local.overseerr_app
      }
    }

    template {
      metadata {
        labels = {
          app = local.overseerr_app
        }
      }

      spec {
        volume {
          name = "overseerr-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.overseerr_config.metadata[0].name
          }
        }

        container {
          name  = local.overseerr_app
          image = "lscr.io/linuxserver/overseerr:latest"

          port {
            container_port = 5055
          }

          volume_mount {
            name       = "overseerr-config"
            mount_path = "/config"
          }
        }
      }
    }
  }

}