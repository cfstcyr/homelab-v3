variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

variable "traefik_app" {
  description = "The name of the Traefik application"
  type        = string
  default     = "traefik"
}