output "database_container_name" {
  description = "Name of the PostgreSQL container"
  value       = docker_container.postgres.name
}

output "database_hostname" {
  description = "Hostname available to containers on the Docker network"
  value       = "database"
}

output "network_name" {
  description = "Docker application network"
  value       = docker_network.application.name
}

output "postgres_volume_name" {
  description = "Persistent PostgreSQL volume"
  value       = docker_volume.postgres_data.name
}