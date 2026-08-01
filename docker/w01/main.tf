terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.2.0"
    }
  }
}

provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_network" "application" {
  name = "w01-network"
}

resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "redis" {
  name = "redis:latest"
}

resource "docker_container" "web" {
  name  = "w01-web"
  image = docker_image.nginx.image_id
  ports {
    internal = 80
    external = 8080
  }
  networks_advanced {
    name = docker_network.application.name
  }
}

resource "docker_container" "cache" {
  name  = "w01-cache"
  image = docker_image.redis.image_id

  networks_advanced {
    name = docker_network.application.name
  }
#   ports {
#     internal = 6379
#     external = 6379
#   }
}