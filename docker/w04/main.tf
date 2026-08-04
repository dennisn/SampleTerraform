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

resource "docker_container" "cache" {
  name  = "w04-cache"
  image = docker_image.service["redis:alpine"].image_id

  networks_advanced {
    name = docker_network.application.name
  }
}

resource "docker_container" "static" {
  name  = "w04-static"
  image = docker_image.service["httpd:alpine"].image_id

  networks_advanced {
    name = docker_network.application.name
  }

  ports {
    internal = 80
    external = 8090
  }
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
