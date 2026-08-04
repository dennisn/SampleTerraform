provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_network" "application" {
  name = "w04-network"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

# resource "docker_container" "web" {
#   count = length(var.web_ports)

#   name  = "w04-web-${count.index + 1}"
#   image = docker_image.nginx.image_id

#   ports {
#     internal = 80
#     external = var.web_ports[count.index]
#   }

#   networks_advanced {
#     name = docker_network.application.name
#   }
# }

resource "docker_container" "web" {
  for_each = var.web_containers

  name  = "w04-web-${each.key}-${each.value.test_label}"
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

moved {
  from = docker_container.web[0]
  to   = docker_container.web["frontend"]
}

moved {
  from = docker_container.web[1]
  to   = docker_container.web["admin"]
}

moved {
  from = docker_container.web[2]
  to   = docker_container.web["report"]
}