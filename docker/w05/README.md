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