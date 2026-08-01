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
3. Does depends_on = [docker_container.database] guarantee PostgreSQL is accepting connections?
4. What relationship does Terraform state record?
5. Why might storing a database password in a sensitive Terraform variable still present a security concern?