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

### Refactoring resource addresses with `moved`

1. Why does renaming a Terraform resource block normally cause a destroy-and-create plan?
2. Does a moved block rename the Docker container itself?
3. What does the moved block change?
4. Why might you retain a moved block after applying the refactor?
5. What should you check in terraform plan before applying a resource rename?
==> 
1. Because Terraform identify resource by its name (i.e. address) --> didn't know the new one is renamed from the old one
2. No, just let Terraform know how the new block is coming to existence
3. The `moved` block changes the **state-address mapping**: same docker container ID remains associated with the resource
4. As other user/environment may still have the old resources
5. Check if Terraform will do a destroy-create or a rename

### More about `moved`
1. What is the main operational difference between a `moved` block and `terraform state mv`?
2. Why is a `moved` block generally safer for multiple environments?
3. Does `terraform state rm` destroy the real Docker resource?
4. What would the next plan likely propose after removing the PostgreSQL container from state but leaving it in configuration?
5. Why could the subsequent apply fail?
6. Why should a state backup be treated as sensitive data?
==>
1. `moved` is declarative, while `terraform state mv` is manually change the state
2. `moved` can be applied to multiple environments automatically via Terraform
3. Not destroy the real Docker resource, just remove it from state file
4. Terraform will propose to recreate the resource
5. It will fail as the resource already exist
6. State backup may contain credentials or other sensitive values

### Import resource
1. Why must a resource block normally exist before importing a resource?
2. Does importing create the Docker resource?
3. Does import guarantee that the configuration matches the real resource?
4. What happens if the imported resource is later removed from configuration?
5. Why can declarative import blocks be useful for team review?
6. What environmental limitation can make hardcoded import IDs inconvenient?
==> 
1. provide the address & desired configuration to which the existing object is mapped
2. No
3. No, only update state to match the real-work state
4. Terraform may try to destroy that resource
5. Declarative imports make the intended state change visible and reviewable in version control
6. IDs are not the same for different environment

### Safely handing off a resource

1. Why is deleting a resource block not the same as relinquishing management?
2. What does `destroy = false` mean inside a removed block?
3. What is the default behaviour when destroy is omitted?
4. Why is a removed block preferable to terraform state rm for team workflows?
5. After applying the removed block, can Terraform still detect drift for that Docker network?
6. What should you verify in the plan before applying a resource hand-off?
==>
1. Delete a resource block will result in that resource being destroyed
2. Mean Terraform will remove the state, but not destroy the resource
3. default behavior to destroy the resource
4. As it's reviewable in source code control
5. No
6. That no resource destroy is plan

### Final review
1. Which mechanism should be used to rename a resource safely?
2. Which mechanism should be used to adopt an existing resource?
3. Which mechanism should be used to relinquish management without destruction?
4. Which lifecycle setting protects a persistent volume from Terraform destruction?
5. Why is depends_on not an application-readiness mechanism?
6. What is the difference between configuration drift and a resource being absent from state?
==>
1. using `moved` block
2. using `import` block
3. using `removed` block with `lifecycle.destroy = false`
4. using `prevent_destroy` in lifecycle block
5. as it's doesn't guarantee the depended on resource being ready
6. configuration drift: resource state change outside of Terraform, hence it will try to update to the desired state. If the resource being absent from state, then it will try to recreate it