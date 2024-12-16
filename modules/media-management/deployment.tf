resource "kubernetes_deployment" "media_management" {
  metadata {
    name = var.media_management_app
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
            claim_name = kubernetes_persistent_volume_claim.sonarr_config.metadata.0.name
          }
        }

        volume {
          name = "${local.radarr_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.radarr_config.metadata.0.name
          }
        }

        volume {
          name = "${local.prowlarr_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.prowlarr_config.metadata.0.name
          }
        }

        volume {
          name = "${local.transmission_app}-config"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.transmission_config.metadata.0.name
          }
        }

        container {
          name = local.vpn_app
          image = "qmcgaw/gluetun:v3.37.0"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          volume_mount {
            name = "tun-device"
            mount_path = "/dev/net/tun"
          }
          
          dynamic "env" {
            for_each = var.vpn_env

            content {
              name = env.key
              value = env.value
            }
            
          }
        }

        container {
          name = local.sonarr_app
          image = "linuxserver/sonarr:latest"

          port {
            container_port = 8989
          }

          volume_mount {
            name = "tv"
            mount_path = "/tv"
          }

          volume_mount {
            name = "${local.sonarr_app}-config"
            mount_path = "/config"
          }
        }

        container {
          name = local.radarr_app
          image = "linuxserver/radarr:latest"

          port {
            container_port = 7878
          }

          volume_mount {
            name = "movies"
            mount_path = "/movies"
          }

          volume_mount {
            name = "${local.radarr_app}-config"
            mount_path = "/config"
          }
        }

        container {
          name = local.prowlarr_app
          image = "lscr.io/linuxserver/prowlarr:latest"

          port {
            container_port = 9696
          }

          volume_mount {
            name = "${local.prowlarr_app}-config"
            mount_path = "/config"
          }
        }

        container {
          name = local.transmission_app
          image = "linuxserver/transmission:latest"

          port {
            container_port = 9091
          }

          volume_mount {
            name = "downloads"
            mount_path = "/downloads"
          }

          volume_mount {
            name = "${local.transmission_app}-config"
            mount_path = "/config"
          }
        }
      }
    }
  }
}
