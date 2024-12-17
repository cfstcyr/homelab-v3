locals {
  pi_hole_hosts = var.pi_hole_subdomain != null ? [for domain in var.reverse_proxy_domains : "${var.pi_hole_subdomain}.${domain}"] : var.reverse_proxy_domains
}

resource "kubernetes_deployment" "pi_hole" {
  metadata {
    name      = var.pi_hole_app
    namespace = var.namespace

    labels = {
      app = var.pi_hole_app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.pi_hole_app
      }
    }

    template {
      metadata {
        labels = {
          app            = var.pi_hole_app
        }
      }

      spec {
        volume {
          name = "${var.pi_hole_app}-dnsmasq"

          host_path {
            path = "/etc/dnsmasq.d"
          }
        }

        container {
          name = var.pi_hole_app
          image = "pihole/pihole:latest"

          security_context {
            capabilities {
              add = ["NET_ADMIN"]
            }
          }

          env {
            name = "WEBPASSWORD"
            value = "123"
          }

          env {
            name = "VIRTUAL_HOST"
            value = join(",", local.pi_hole_hosts)
          }

          env {
            name = "DNSMASQ_LISTENING"
            value = "all"
          }

          port {
            container_port = 80
          }

          port {
            container_port = 53
          }

          volume_mount {
            name = "${var.pi_hole_app}-dnsmasq"
            mount_path = "/etc/dnsmasq.d"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "pi_hole_web" {
  metadata {
    name      = "${var.pi_hole_app}-web"
    namespace = var.namespace

    labels = {
      app = var.pi_hole_app
    }
  }

  spec {
    selector = {
      app = var.pi_hole_app
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "pi_hole_dns" {
  metadata {
    name      = "${var.pi_hole_app}-dns"
    namespace = var.namespace

    labels = {
      app = var.pi_hole_app
    }
  }

  spec {
    selector = {
      app = var.pi_hole_app
    }

    type = "LoadBalancer"

    port {
      name = "dns"
      port        = 5053
      target_port = 53
    }
  }
}

resource "kubernetes_ingress_v1" "pi_hole_web" {
  metadata {
    name      = "${var.pi_hole_app}-web"
    namespace = var.namespace

    annotations = {
      "gethomepage.dev/enabled" : "true",
      "gethomepage.dev/name" : "Pi-hole",
      "gethomepage.dev/icon" : "pi-hole",
      "gethomepage.dev/group" : "Tools",
      "gethomepage.dev/weight" : "35",
      "gethomepage.dev/widget.type" : "pihole",
      "gethomepage.dev/widget.url" : "http://${kubernetes_service.pi_hole_web.metadata[0].name}:80",
      "gethomepage.dev/pod-selector" : "",
    }
  }

  spec {
    dynamic "rule" {
      for_each = local.pi_hole_hosts

      content {
        host = rule.value

        http {
          path {
            path = "/"

            backend {
              service {
                name = kubernetes_service.pi_hole_web.metadata[0].name
                port {
                  number = 80
                }
              }
            }
          }
        }
      }
    }
  }
}