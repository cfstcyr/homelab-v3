resource "kubernetes_persistent_volume_claim" "radarr_config" {
  metadata {
    name      = "radarr-config"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "500Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "sonarr_config" {
  metadata {
    name      = "sonarr-config"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "500Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "prowlarr_config" {
  metadata {
    name      = "prowlarr-config"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "200Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "transmission_config" {
  metadata {
    name      = "transmission-config"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "50Mi"
      }
    }
  }
}

resource "kubernetes_persistent_volume_claim" "overseerr_config" {
  metadata {
    name      = "overseerr-config"
    namespace = var.namespace
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "50Mi"
      }
    }
  }
}