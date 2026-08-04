# Refactor existing terraform to use modules
- Refactor the configuration in "../w04" to use modules

## Knowledge check

1. What is the difference between the root module and a child module?
2. Why does the child module declare required_providers but not configure provider "docker"?
3. What does source = "./modules/docker-container" mean?
4. Why are internal_port and external_port assigned null defaults?
5. How does the dynamic "ports" block omit the port mapping for Redis?
6. What is the full resource address of the static container after applying for_each to the module?
7. How do you reference the cache module’s name output?
8. Why is a moved block needed when moving a resource into a child module?
9. What is the difference between a module input and a module output?
10. Should every individual resource be wrapped in a module? Explain the trade-off.

==>
1. The root module is the directory where Terraform is executed. A child module is a configuration called by another module and may contain multiple resources and other Terraform constructs
2. Provider connection details belong in the root because they are environment-specific and can be shared by child modules. Child modules declare only their provider requirements
3. meaning the child module is in that folder
4. The `null` defaults make port inputs optional and allow the module to represent containers without published ports.
5. It's omit by `for_each (<condition>) ? [1] : []` --> The conditional returns [1] to generate one ports block or [] to generate none
6. address = `module.application_service["static"].docker_container.this`
7. module.application_service["cache"].name
8. As the address has changed
9. Module inputs are values supplied by the caller. Module outputs expose selected values back to the caller
10. A module is useful when it creates a meaningful abstraction. However, wrapping every resource create unnecessary abstraction
    --> Create a module when it represents a reusable or meaningful infrastructure concept, not merely to reduce line count