variable "environment" {
  description = "Environment identifier used in Docker resource names"
  type        = string
  default     = "Dev"

  validation {
    condition = contains(
      ["Dev", "Test", "Prod"],
      var.environment
    )

    error_message = "Environment must be Dev, Test or Prod"
  }
}

variable "web_image" {
  description = "Docker image used by the web container"
  type        = string
  default     = "nginx:1.29-alpine"
}

variable "cache_image" {
  description = "Docker image used by the cache container"
  type        = string
  default     = "redis:8-alpine"
}

variable "web_external_port" {
  description = "Host port mapped to the web container"
  type        = number
  default     = 8080

  validation {
    condition = (
      var.web_external_port >= 1024 &&
      var.web_external_port <= 65535
    )
    error_message = "The external port must be between 1024 and 65535"
  }
}

variable "images" {
  description = "Docker images used by the application"

  type = object({
    web = string
    cache = string
  })
  
  default = {
    web = "nginx:1.29-alpine"
    cache = "redis:8-alpine"
  }
}