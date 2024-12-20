terraform {
  backend "s3" {
    bucket                      = "homelab-terraform"
    key                         = "terraform-v3.tfstate"
    region                      = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
    endpoints = {
      s3 = "https://31e73b1b7ab727f65ac38d3197dd6630.r2.cloudflarestorage.com"
    }
  }

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.40"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.16"
    }
  }

  required_version = "~> 1.10.2"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "docker-desktop"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token != null ? var.cloudflare_api_token : "THIS_IS_NOT_AN_API_TOKEN________________"
}