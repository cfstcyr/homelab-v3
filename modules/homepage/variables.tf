variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

variable "homepage_app" {
  description = "The name of the Homepage application"
  type        = string
  default     = "homepage"
}