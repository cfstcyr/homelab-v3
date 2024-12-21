# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

variable "config_path" {
  description = "The path to the configuration directory"
  type        = string
}

variable "buildarr_app" {
  description = "The name of the Builarr application"
  type        = string
}

variable "target_app" {
  description = "The name of the target application"
  type        = string
}

variable "target_config_file_name" {
  description = "The name of the Buildarr configuration file (ex: radarr.yml)"
  type        = string
}

variable "target_config_prefix" {
  description = "The prefix for the Buildarr configuration file (ex: radarr_)"
  type        = string
}

variable "target_config_extra" {
  description = "Extra configuration for the Buildarr target"
  type        = map(string)
  default     = {}
}

variable "target_hostname" {
  description = "Hostname for the Buildarr target"
  type        = string
}

variable "target_port" {
  description = "Port for the Buildarr target"
  type        = number
}

variable "target_api_key" {
  description = "API key for the Buildarr target"
  type        = string
}

# variable "radarr_hostname" {
#   type        = string
#   description = "Hostname for Radarr"
# }

# variable "radarr_api_key" {
#   type        = string
#   description = "API key for Radarr"
# }

# variable "sonarr_hostname" {
#   type        = string
#   description = "Hostname for Sonarr"
# }

# variable "sonarr_api_key" {
#   type        = string
#   description = "API key for Sonarr"
# }

# variable "prowlarr_hostname" {
#   type = string
#   description = "Hostname for Prowlarr"
# }

# variable "prowlarr_api_key" {
#   type        = string
#   description = "API key for Prowlarr"
# }