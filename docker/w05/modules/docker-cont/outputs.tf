output "id" {
  description = "Docker container ID"
  value       = docker_container.this.id
}

output "name" {
  description = "Docker container name"
  value       = docker_container.this.name
}

output "network_data" {
  description = "Container network information"
  value       = docker_container.this.network_data
}