resource "kubernetes_ingress_v1" "sonarr" {
  metadata {
    name      = local.sonarr_app
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Sonarr",
      "gethomepage.dev/icon" : "sonarr",
      "gethomepage.dev/group" : "Management",
      "gethomepage.dev/weight" : "15",
      "gethomepage.dev/widget.type" : "sonarr",
      "gethomepage.dev/widget.url" : "http://${local.sonarr_app}:8989",
      "gethomepage.dev/widget.key" : random_id.sonarr_api_key.hex,
      "gethomepage.dev/pod-selector"  : "app=${var.media_management_app}"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.sonarr_subdomain != null ? "${var.sonarr_subdomain}.${rule.value}" : rule.value
        http {
          path {
            path = "/"

            backend {
              service {
                name = "sonarr"
                port {
                  number = 8989
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "radarr" {
  metadata {
    name      = "radarr"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Radarr",
      "gethomepage.dev/icon" : "radarr",
      "gethomepage.dev/group" : "Management",
      "gethomepage.dev/weight" : "10",
      "gethomepage.dev/widget.type" : "radarr",
      "gethomepage.dev/widget.url" : "http://${local.radarr_app}:7878",
      "gethomepage.dev/widget.key" : random_id.radarr_api_key.hex,
      "gethomepage.dev/pod-selector"  : "app=${var.media_management_app}"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.radarr_subdomain != null ? "${var.radarr_subdomain}.${rule.value}" : rule.value
        http {
          path {
            path = "/"

            backend {
              service {
                name = "radarr"
                port {
                  number = 7878
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "transmission" {
  metadata {
    name      = "transmission"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Transmission",
      "gethomepage.dev/icon" : "transmission",
      "gethomepage.dev/group" : "Tools",
      "gethomepage.dev/weight" : "10",
      "gethomepage.dev/widget.type" : "transmission",
      "gethomepage.dev/widget.url" : "http://${local.transmission_app}:9091",
      "gethomepage.dev/pod-selector"  : "app=${var.media_management_app}"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.transmission_subdomain != null ? "${var.transmission_subdomain}.${rule.value}" : rule.value
        http {
          path {
            path = "/"

            backend {
              service {
                name = "transmission"
                port {
                  number = 9091
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "prowlarr" {
  metadata {
    name      = "prowlarr"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Prowlarr",
      "gethomepage.dev/icon" : "prowlarr",
      "gethomepage.dev/group" : "Management",
      "gethomepage.dev/widget.type" : "prowlarr",
      "gethomepage.dev/weight" : "50",
      "gethomepage.dev/widget.url" : "http://${local.prowlarr_app}:9696",
      "gethomepage.dev/widget.key" : random_id.prowlarr_api_key.hex,
      "gethomepage.dev/pod-selector"  : "app=${var.media_management_app}"
    }
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.prowlarr_subdomain != null ? "${var.prowlarr_subdomain}.${rule.value}" : rule.value
        http {
          path {
            path = "/"

            backend {
              service {
                name = "prowlarr"
                port {
                  number = 9696
                }
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_ingress_v1" "overseerr" {
  metadata {
    name      = "overseerr"
    namespace = var.namespace

    annotations = merge(
      {
        "gethomepage.dev/enabled" : "true",
        "gethomepage.dev/name" : "Overseerr",
        "gethomepage.dev/icon" : "overseerr",
        "gethomepage.dev/group" : "Management",
        "gethomepage.dev/weight" : "5",
        "gethomepage.dev/pod-selector" : "app=${local.overseerr_app}",
      },
      var.overseerr_api_key != null ? {
        "gethomepage.dev/widget.type" : "overseerr",
        "gethomepage.dev/widget.url" : "http://${local.overseerr_app}:5055",
        "gethomepage.dev/widget.key" : var.overseerr_api_key,
      } : {},
    )
  }

  spec {
    dynamic "rule" {
      for_each = var.reverse_proxy_domains

      content {
        host = var.overseerr_subdomain != null ? "${var.overseerr_subdomain}.${rule.value}" : rule.value
        http {
          path {
            path = "/"

            backend {
              service {
                name = local.overseerr_app
                port {
                  number = 5055
                }
              }
            }
          }
        }
      }
    }
  }
}