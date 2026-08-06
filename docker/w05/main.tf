terraform {
  required_version = ">= 1.7.0"

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }

  backend "local" {
    path = "state/terraform.tfstate"
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

locals {
  resource_prefix = "w05-${terraform.workspace}"
}

resource "docker_network" "application" {
  name = "${local.resource_prefix}-network"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

# resource "docker_image" "service" {
#   for_each = toset([
#     "redis:alpine",
#     "httpd:alpine"
#   ])

#   name = each.value
# }

resource "docker_container" "web" {
  for_each = var.web_containers

  name  = "${local.resource_prefix}-web-${each.key}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = each.value.external_port
  }

  labels {
    label = "test_label"
    value = each.value.test_label
  }

  networks_advanced {
    name = docker_network.application.name
  }
}

# module "cache" {
#   source = "./modules/docker-cont"

#   name         = "w05-cache"
#   image_id     = docker_image.service["redis:alpine"].image_id
#   network_name = docker_network.application.name

#   labels = {
#     service = "cache"
#     method  = "module"
#   }
# }

# module "static" {
#   source = "./modules/docker-cont"

#   name          = "w05-static"
#   image_id      = docker_image.service["httpd:alpine"].image_id
#   network_name  = docker_network.application.name
#   internal_port = 80
#   external_port = 8090

#   labels = {
#     service = "static"
#     method  = "module"
#   }
# }

resource "docker_image" "service" {
  for_each = var.application_services

  name = each.value.image
}

module "application_service" {
  for_each = var.application_services

  source = "./modules/docker-cont"

  name         = "${local.resource_prefix}-${each.key}"
  image_id     = docker_image.service[each.key].image_id
  network_name = docker_network.application.name

  internal_port = each.value.internal_port
  external_port = each.value.external_port
  labels        = each.value.labels
}

moved {
  from = module.cache.docker_container.this
  to   = module.application_service["cache"].docker_container.this
}

moved {
  from = module.static.docker_container.this
  to   = module.application_service["static"].docker_container.this
}