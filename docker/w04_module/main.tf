terraform {
  required_version = ">= 1.7.0"

  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_network" "application" {
  name = "w04-network"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_image" "service" {
  for_each = toset([
    "redis:alpine",
    "httpd:alpine"
  ])

  name = each.value
}

resource "docker_container" "web" {
  for_each = var.web_containers

  name  = "w04-web-${each.key}"
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

module "cache" {
  source = "./modules/docker-cont"

  name         = "w04-cache"
  image_id     = docker_image.service["redis:alpine"].image_id
  network_name = docker_network.application.name

  labels = {
    service = "cache"
    method  = "module"
  }
}

module "static" {
  source = "./modules/docker-cont"

  name          = "w04-static"
  image_id      = docker_image.service["httpd:alpine"].image_id
  network_name  = docker_network.application.name
  internal_port = 80
  external_port = 8090

  labels = {
    service = "static"
    method  = "module"
  }
}