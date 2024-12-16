resource "kubernetes_ingress_v1" "sonarr" {
  metadata {
    name = "sonarr"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled": "true",
      "gethomepage.dev/name": "Sonarr",
      "gethomepage.dev/icon": "sonarr",
      "gethomepage.dev/group": "Management",
      "gethomepage.dev/pod-selector": "",
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
    name = "radarr"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled": "true",
      "gethomepage.dev/name": "Radarr",
      "gethomepage.dev/icon": "radarr",
      "gethomepage.dev/group": "Management",
      "gethomepage.dev/pod-selector": "",
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
    name = "transmission"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled": "true",
      "gethomepage.dev/name": "Transmission",
      "gethomepage.dev/icon": "transmission",
      "gethomepage.dev/group": "Management",
      "gethomepage.dev/pod-selector": "",
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
    name = "prowlarr"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled": "true",
      "gethomepage.dev/name": "Prowlarr",
      "gethomepage.dev/icon": "prowlarr",
      "gethomepage.dev/group": "Management",
      "gethomepage.dev/pod-selector": "",
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