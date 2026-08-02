provider "docker" {
  host = "npipe:////.//pipe//docker_engine"
}

resource "docker_network" "application" {
  name = "w04-network"
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}