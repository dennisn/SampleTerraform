provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_network" "application" {
  name = "w04-network"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "web" {
  count = length(var.web_ports)

  name  = "w04-web-${count.index + 1}"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.web_ports[count.index]
  }

  networks_advanced {
    name = docker_network.application.name
  }
}