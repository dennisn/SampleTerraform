# Week 6 — Remote State, Backends and Team Workflows

Week 5 covered separating root modules and accessing selected outputs through terraform_remote_state. Week 6 focuses on storing state safely and allowing multiple engineers or automation pipelines to work with the same infrastructure.

## Learning objectives

By the end of this week, you should understand:

- Local versus remote state
- Terraform backends
- State locking
- Backend initialisation and migration
- Sensitive state considerations
- Workspace limitations
- A practical team workflow
- Preparing for cloud-hosted Terraform state

## Checking questions

### Set 1
1. What is the difference between a backend and a provider?
2. Why is local state unsuitable for a shared team environment?
3. Can backend configuration refer to `var.environment`?
4. What does `terraform init -migrate-state` do?
5. What is the risk of using `terraform init -reconfigure` incorrectly?
6. What problem does state locking prevent?
7. Does marking a value sensitive remove it from the state file?
8. Should `.terraform.lock.hcl` normally be committed to Git?
9. Do Terraform workspaces provide complete security and credential isolation?
10. Why might separate environment root modules be preferable to CLI workspaces?
==> 
1. Backend is for handling of Terraform state, while provider is for communicate with the infrastructure platform
2. Local state is locally available only --> Different machines will not have the same state
3. No, as backend is processed early in `init`
4. Move/Copy the state from old backend to new
5. Start with empty state without migrating the old state automatically --> all existing resources become unmanaged
6. State locking prevents concurrent Terraform operations from modifying the same state simultaneously, which could otherwise overwrite or corrupt state.
7. no
8. `.terraform.lock.hcl` should normally be committed to Git. It records selected provider versions/checksums, helping different developers and CI use consistent provider packages.
9. No
10. As it provides explicit separation, where each environment can provide 
    - Backend
    - Provider/account/subscription
    - Credentials