# Week 3 — Dependencies, Lifecycle, and State

This week builds on your Docker configuration and covers:
1. Implicit and explicit dependencies
2. Terraform’s dependency graph
3. Resource lifecycle behaviour
4. Inspecting and safely modifying state
5. Refactoring with moved
6. Importing existing resources
7. Removing resources from Terraform management without destroying them

### Resource dependencies
- Terraform does not generally execute resources in the order they appear in .tf files.
  - Instead, it constructs a directed dependency graph and creates independent resources concurrently where possible --> These are call implicit dependencies
  - Terraform recommends explicit `depends_on` only for hidden behavioural dependencies that cannot be expressed through normal attribute references

### Terraform state
State is necessary because Terraform uses it to:
- associate configuration addresses with real infrastructure;
- retain resource metadata;
- compare desired configuration with existing resources;
- determine create, update, replace and destroy operations

## Checkpoint questions
1. Why does docker_container.database depend on docker_volume.postgres_data without using depends_on?
2. Would moving the network resource below the container resource change creation order?
3. Does `depends_on = [docker_container.database]` guarantee PostgreSQL is accepting connections?
4. What relationship does Terraform state record?
5. Why might storing a database password in a sensitive Terraform variable still present a security concern?

==> 
1. Because `docker_volume.postgres_data.name` is used as `volume_name` within `docker_container.database`
2. No
3. No
4. Terraform state primarily records the mapping between a Terraform resource address and the real infrastructure object
5. It's still a security risk as you still have its on files (e.g. `terraform.tfvars`, `terraform.tfstate`, state backups, remote state storage), in clear text --> only redacts normal CLI output, but doesn't encrypt or remove the value from state

### Lifecycle questions
1. Why is protecting the volume generally more important than protecting the container?
2. Does prevent_destroy protect the volume if someone deletes it directly using Docker?
3. What happens if you remove the entire volume resource block from the configuration while `prevent_destroy` is present?
4. Is prevent_destroy stored in Terraform state or derived from the current configuration?
==>
1. Because the volume contains the data, which should be persistent over time
2. no
3. then the `prevent_destroy` will not be found, and terraform will destroy the volume
4. from the current configuration

### More Lifecycle questions
1. Why might `create_before_destroy` fail for a Docker container exposing host port `8080`?
2. Does `ignore_changes` prevent someone from changing a resource outside Terraform?
3. After adding `ignore_changes = [labels]`, which value owns the labels in practice: Terraform or the external system?
4. Why is `ignore_changes = all` generally dangerous?
5. Which lifecycle rule would you apply to the PostgreSQL volume, and which lifecycle rule might be appropriate for externally managed metadata?
==> 
1. as new docker container can't be created on the same host port
2. no
3. external system
4. as it will hide configuration drift, practically stop Terraform from manage the resource
5. for volume, should use `prevent_destroy`. For externally managed metadata, `ignore_changes`