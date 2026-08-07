terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "application" {
    name = "w06-${var.environment}-network"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "web" {
  name = "w06-${var.environment}-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.ext_port
  }

  networks_advanced {
    name = docker_network.application.name
  }
}