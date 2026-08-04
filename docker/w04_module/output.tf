output "web_container_names" {
  #value = docker_container.web.name
  value = [for instance in docker_container.web : instance.name]
}

output "web_container_names_map" {
  value = { for key, instance in docker_container.web : key => instance.name }
}

output "web_container_test_label" {
  value = [for instance in docker_container.web : instance.labels]
}

# output "cache_container_name" {
#   value = module.application_service["cache"].name
# }

# output "static_container_name" {
#   value = module.application_service["static"].name
# }

output "application_service_names" {
  value = [for instance in module.application_service: instance.name]
}

output "static_network_data" {
  value = module.application_service["static"].network_data
}