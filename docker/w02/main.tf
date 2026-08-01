terraform {
  required_version = ">= 1.8.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.2.0"
    }
  }
}

provider "docker" {}

locals {
  resource_prefix = "w02-${var.environment}"
  common_labels = {
    managed_by  = "terraform"
    environment = var.environment
  }
}

resource "docker_network" "application" {
  name = "${local.resource_prefix}-network"

  labels {
    label = "managed_by"
    value = local.common_labels.managed_by
  }

  labels {
    label = "environment"
    value = local.common_labels.environment
  }
}

resource "docker_image" "nginx" {
  name = var.web_image
}

resource "docker_image" "redis" {
  name = var.cache_image
}

resource "docker_container" "web" {
  name  = "${local.resource_prefix}-web"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = var.web_external_port
  }
  networks_advanced {
    name = docker_network.application.name
  }

  labels {
    label = "managed_by"
    value = local.common_labels.managed_by
  }

  labels {
    label = "environment"
    value = local.common_labels.environment
  }
}

resource "docker_container" "cache" {
  name  = "${local.resource_prefix}-cache"
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.application.name
  }

  labels {
    label = "managed_by"
    value = local.common_labels.managed_by
  }

  labels {
    label = "environment"
    value = local.common_labels.environment
  }
}