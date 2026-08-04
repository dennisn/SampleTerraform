variable "name" {
  description = "Docker container name"
  type = string
}

variable "image_id" {
  description = "Docker image id"
  type = string
}

variable "network_name" {
  description = "Docker network attached to the container"
  type = string
}

variable "internal_port" {
  description = "Port exposed inside the container"
  type = number
  default = null
}

variable "external_port" {
  description = "Port published on the Docker host"
  type = number
  default = null
}

variable "labels" {
  description = "Labels assigned to the container"
  type = map(string)
  default = {}
}