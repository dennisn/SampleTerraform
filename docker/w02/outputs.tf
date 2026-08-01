output "web_container_name" {
  description = "Name of the web container"
  value       = docker_container.web.name
}

output "cache_container_name" {
  description = "Name of the cache container"
  value       = docker_container.cache.name
}

output "network_name" {
  description = "Docker network used by the application"
  value       = docker_network.application.name
}

output "web_url" {
  description = "URL used to access the Nginx container"
  value       = "http://localhost:${var.web_external_port}"
}

output "container_ids" {
  description = "Map of container names to Docker container IDs"

  value = {
    web   = docker_container.web.id
    cache = docker_container.cache.id
  }
}