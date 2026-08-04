output "web_container_names" {
  #value = docker_container.web.name
  value = [for instance in docker_container.web : instance.name]
}

output "web_container_names_name" {
  value = { for key, instance in docker_container.web : key => instance.name }
}

output "web_container_test_label" {
  value = [for instance in docker_container.web : instance.labels]
}