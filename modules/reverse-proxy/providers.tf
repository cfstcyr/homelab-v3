terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
    
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}
