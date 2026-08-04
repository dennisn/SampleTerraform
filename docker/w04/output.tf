output "web_container_names" {
  value = docker_container.web[*].name
}