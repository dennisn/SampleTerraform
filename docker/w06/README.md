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

### Set 2
1. If development and production state are stored in the same S3 bucket but under different `key` values, are they the same Terraform state?
2. Why is state locking required even when state is already stored remotely?
3. What does `terraform force-unlock` do, and why is it dangerous?
4. Does state locking prevent an engineer from manually changing a resource through the cloud console?
5. Give two reasons for splitting a large infrastructure into multiple states.
6. Is one state per Terraform resource generally a good architecture?
7. Why shouldn't backend credentials normally be hardcoded in backend blocks?
8. What is the Terraform backend bootstrap problem?
9. Which should generally exist first: the remote backend infrastructure or the root module that uses that backend?
10. Suppose networking and application have separate states. Which Week 5 mechanism could application use to consume explicitly exported values from networking?
==>
1. They are different state
2. As concurrent terraform operations can still overwrite/corrupt state
3. remove  the lock without the normal owner releasing it --> must ensure no terraform operation is still running
4. No
5. Reduce contention with lock, and fine-grain permission/ownership of resources
6. No, excessive dependencies & coordination
7. The main issue is that backend credentials can leak into Terraform's local metadata and potentially saved plan files or shell history, depending on how they are supplied
8. When resource needed for terraform backend need to exist before terraform can run
9. the remote backend infrastructure need to exist first
10. Using `terraform_remote_state`

### Set 3
Assume this repository:
```text
terraform/
├── bootstrap/
├── modules/
│   ├── networking/
│   └── application/
└── environments/
    ├── development/
    │   ├── networking/
    │   └── application/
    └── production/
        ├── networking/
        └── application/
```
1. Which directories above should normally contain Terraform root modules?
2. Which directory contains reusable child modules?
3. Should development and production share the same state object?
4. Can development and production use the same remote-state bucket?
5. If they use the same bucket, what must be different to keep their state separate?
6. Why might production/networking and production/application use separate state files?
7. Which one should normally be deployed first: networking or application?
8. If application needs vpc_id from networking, what must networking declare?
9. What Terraform mechanism can application use to read that value from networking state?
10. What is the difference between:
```hcl
terraform plan
terraform apply
```

and:

```hcl
terraform plan -out=tfplan
terraform apply tfplan
```
11. Why does state locking not completely solve concurrent-deployment problems in CI?
12. Why should tfplan files be treated as sensitive?
13. If terraform validate passes, does that guarantee terraform apply will succeed?
14. Name two protections you would add specifically around production deployments.
15. Why are short-lived OIDC credentials preferable to long-lived cloud access keys in CI?
==>
1. networking and application under both development & production
2. networking & application under modules
3. No
4. Yes
5. Use different key/path
6. To reduce blast radius, reduce contention & different ownership/deployment cycle
7. networking should be first
8. networking must expose vpc_id through its output
9. `terraform_remote_state`
10. The second produce a plan file, which can be review & authorised before apply the exact plan --> consistency & auditability. The first may generate a new plan
11. As its only stop state being overwritten. Example: networking apply in one pipeline & application apply in another
12. It may contain sensitive sensitive configuration and resource values, including passwords, tokens or other secrets.
13. No
14. Different state key & cloud account 
15. OIDC allows CI to obtain short-lived credential --> if exposed, their useful lifetime is much shorter