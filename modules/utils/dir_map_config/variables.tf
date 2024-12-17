variable "name" {
  type = string
  description = "The name of the config map"
}

variable "namespace" {
  type = string
  description = "The namespace to create the config map in"
}

variable "dir" {
  type = string
  description = "The directory to read files from"
}

variable "glob" {
  type = string
  description = "The glob pattern to match files"
  default = "*"
}

variable "template_vars" {
  type = map
  description = "The variables to pass to the template"
  default = {}
}