variable "project_name" {
  description = "Prefix used for Docker resource name"
  type        = string
  default     = "w03"
}

variable "postgres_db" {
  description = "Application database name"
  type        = string
  default     = "application"
}

variable "postgres_user" {
  description = "PostgreSQL application user"
  type        = string
  default     = "app_user"
}

variable "postgres_password" {
  description = "PostgreSQL application password"
  type        = string
  sensitive   = true
}