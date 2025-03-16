# Global

variable "namespace" {
  description = "The namespace to use for the resources in this module"
  type        = string
}

# Postgres

variable "postgres_app" {
  description = "The name of the Postgres application"
  type        = string
  default     = "postgres"
}

variable "postgres_capacity" {
  description = "The capacity of the Postgres persistent volume"
  type        = string
  default     = "1Gi"
}

variable "postgres_username" {
  description = "The username for the Postgres database"
  type        = string
  default     = "admin"
}

# PGAdmin

variable "pgadmin_app" {
  description = "The name of the pgAdmin application"
  type        = string
  default     = "pgadmin"
}

variable "pgadmin_default_email" {
  description = "The default email for pgAdmin"
  type        = string
  default     = "admin@admin.ca"
}

variable "pgadmin_default_password" {
  description = "The default password for pgAdmin"
  type        = string
  default     = "admin"
}

# Routing

variable "reverse_proxy_domains" {
  type        = list(string)
  description = "Domains for the homelab"
}

variable "pgadmin_subdomain" {
  type        = string
  description = "Domain for PGAdmin"
}