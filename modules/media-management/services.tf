resource "kubernetes_service" "vpn" {
  metadata {
    name = "vpn"
    namespace = var.namespace
    labels = {
      app = var.media_management_app
    }
  }

  spec {
    selector = {
      app = var.media_management_app
    }

    port {
      port        = 8000
      target_port = 8000
    }
  }
}

resource "kubernetes_service" "sonarr" {
  metadata {
    name = "sonarr"
    namespace = var.namespace

    labels = {
      app = var.media_management_app
    }
  }

  spec {
    selector = {
      app = var.media_management_app
    }

    port {
      port        = 8989
      target_port = 8989
    }
  }
}

resource "kubernetes_service" "radarr" {
  metadata {
    name = "radarr"
    namespace = var.namespace

    labels = {
      app = var.media_management_app
    }
  }

  spec {
    selector = {
      app = var.media_management_app
    }

    port {
      port        = 7878
      target_port = 7878
    }
  }
}

resource "kubernetes_service" "prowlarr" {
  metadata {
    name = "prowlarr"
    namespace = var.namespace

    labels = {
      app = var.media_management_app
    }
  }

  spec {
    selector = {
      app = var.media_management_app
    }

    port {
      port        = 9696
      target_port = 9696
    }
  }
}

resource "kubernetes_service" "transmission" {
  metadata {
    name = "transmission"
    namespace = var.namespace

    labels = {
      app = var.media_management_app
    }
  }

  spec {
    selector = {
      app = var.media_management_app
    }

    port {
      port        = 9091
      target_port = 9091
    }
  }
}

resource "kubernetes_service" "overseerr" {
  metadata {
    name = "overseerr"
    namespace = var.namespace

    labels = {
      app = var.media_management_app
    }
  }

  spec {
    selector = {
      app = var.media_management_app
    }

    port {
      port        = 5055
      target_port = 5055
    }
  }
}