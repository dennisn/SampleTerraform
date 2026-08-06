# Week 5 — State, Backends, Locking, and Workspaces

This week shifts from writing reusable Terraform code to managing Terraform safely across environments and teams.

## Learning objectives

By the end of Week 5, you should understand:
- What Terraform state contains
- Why state must be protected
- Local versus remote backends
- State locking
- Backend initialisation and migration
- Terraform workspaces
- When workspaces are appropriate
- Why separate root modules are often preferable for major environments

## Questions

### Set 1

1. What is the difference between Terraform configuration and Terraform state?
2. Why might Terraform try to create a duplicate resource if its state entry is lost?
3. Is a backend the same thing as a provider?
4. Which command processes a backend configuration change?
5. Does marking a variable `sensitive = true` guarantee its value is absent from state?
6. Why is state locking important when multiple engineers use Terraform?
7. What should you verify before using `terraform force-unlock`?
8. If state is moved from `terraform.tfstate` to `state/terraform.tfstate`, should Terraform recreate the Docker containers?
==>
1. Configuration declares the desired infrastructure. State maps Terraform resource addresses to real infrastructure objects and records their last-known attributes.
2. Terraform may interpret the missing state entry as an unmanaged or nonexistent resource and attempt to create a new one.
3. No, backend manage how state is stored
4. `init` or `terraform init -migrate-state`
5. no, only suppresses CLI display
6. To avoid engineer override states of each other
7. That no other session is owning the lock
8. No

### Set 2
1. What does a Terraform workspace isolate?
2. Do different workspaces use different Terraform configuration files automatically?
3. Why must Docker container names and ports differ between workspaces?
4. What does `terraform.workspace` return?
5. Can a workspace automatically provide separate AWS accounts or credentials?
6. Why can workspaces be risky for production environments?
7. When might separate root-module directories be preferable to workspaces?
8. Two workspaces both contain the address docker_container.web. Does that mean they manage the same container?
==>
1. Isolate state
2. No
3. As same name & ports will be conflicted & failed
4. Current workspace name
5. No
6. accidentally selecting the wrong workspace and successfully modifying the wrong environment
7. When substaintial different infrastructure (e.g. security, account, lifecycle & ownership)
8. No

### Set 3
1. What does `terraform state list` display?
2. Does `terraform state show` query a resource by its Docker container name or by its Terraform address?
3. What happens to a real Docker container after `terraform state rm` removes its state entry?
4. Why might the next plan propose creating the container again?
5. What is the difference between `terraform state mv` and a `moved` block?
6. Why should output from `terraform state pull` be protected?
7. Is `terraform state push` an ordinary deployment command?
8. Does switching workspaces change which state is inspected by `terraform state list`?
==>
1. Shows Terraform resource addresses
2. by its address
3. Nothing change, but Terraform not managed it anymore
4. As it doesn't recognise the resources
5. One is manual, and must be apply for each environment. The latter will let Terraform know automatically
6. As its may contain sensitive properties
7. No, very risky operation --> recovery only.
8. yes

### Set 4
1. What is configuration drift?
2. Why does Terraform propose recreating a manually deleted resource?
3. What is the difference between `terraform plan` and `terraform plan -refresh-only`?
4. Does `terraform apply -refresh-only` normally create or destroy infrastructure?
5. Why is `terraform apply -refresh-only` generally preferable to `terraform refresh`?
6. Can refresh automatically discover and manage a manually created container?
7. What operation is needed to bring an existing unmanaged resource into Terraform state?
8. Does `ignore_changes` mean Terraform cannot observe the external change?
==>
1. Configuration drift occurs when real infrastructure differs from the configuration Terraform is intended to enforce. Stored state can also become outdated until Terraform refreshes it.
2. As it can't find that resource anymore
3. The first will try to change actual state to match those declared by configuration. The second focuses on update stored state
4. no
5. As it allow for preview of changes
6. No
7. Need `import` operation, or `terraform import`
8. No

### Set 5
1. Why might infrastructure be divided across multiple Terraform states?
2. What should a root module use to expose selected values to another configuration?
3. Does `terraform_remote_state` read resource addresses directly from another configuration?
4. What expression reads the network_name output in the example?
5. Why can granting access to remote-state outputs expose more information than expected?
6. Does marking an output `sensitive = true` remove it from state?
7. Does `terraform_remote_state` automatically apply the producer configuration before the consumer?
8. Why should root-module outputs be treated like stable APIs?
9. In the exercise, which should be destroyed first: the application or networking configuration?
==>
1. Multiple states reduce scope and allow infrastructure areas to have separate ownership, permissions, deployment cycles, and failure boundaries.
2. outputs
3. No, it read through "outputs"
4. `data.terraform_remote_state.networking.outputs.network_name`
5. As it implies access to the whole underlying state
6. No
7. No. Deployment order must be handled separately through pipelines, scripts, or operational procedures.
8. As other root-module may depend/use it for their own configuration
9. The application

## Summary
You have covered:

- Terraform state as the mapping between resource addresses and real objects
- Local and remote backends
- Backend migration with terraform init -migrate-state
- State locking and force-unlock
- CLI workspaces and their limitations
- State inspection with state list, state show, and state pull
- Imperative state operations versus declarative moved and removed blocks
- Drift detection and refresh-only plans
- Multiple state boundaries
- Sharing root outputs through terraform_remote_state
- Security and coupling risks of cross-state access

The central Week 5 principle is:
> Terraform state is operational infrastructure data, not merely a generated local file.

For production systems, state should generally be remotely stored, encrypted, access-controlled, versioned, and protected against concurrent writes.