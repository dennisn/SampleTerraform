# Week 7 — Terraform Testing, Validation, and CI/CD

> How do we detect bad infrastructure changes before they reach production?

Roadmap
| Part | Topic                        | Main idea                                    |
| ---- | ---------------------------- | -------------------------------------------- |
| 7.1  | Terraform validation         | Catch configuration errors early             |
| 7.2  | Formatting and static checks | Make configuration consistent and reviewable |
| 7.3  | Saved plans                  | Separate review from execution               |
| 7.4  | CI pipeline design           | Run Terraform checks automatically           |
| 7.5  | Terraform tests              | Test infrastructure behaviour                |
| 7.6  | Production workflow          | Build a safe `plan → review → apply` process |
| 7.7  | Week 7 exercise              | Build a CI-ready Terraform project           |

## Exercise

### Set 1
Assume this configuration
```hcl
variable "environment" {
  type = string
}

variable "external_port" {
  type = number
}

resource "docker_image" "nginx" {
  name = "nginx:alpine"
}

resource "docker_container" "web" {
  name  = "${var.environment}-web"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.external_port
  }
}
```
Answer these without running Terraform
1. What does `terraform fmt -check` verify?
2. Does `terraform fmt -check` modify the .tf files?
3. What does `terraform validate` primarily check?
4. Suppose external_port = 8080 becomes 9090. Could terraform validate succeed even if Terraform intends to replace the container?
5. Which command tells you about that replacement?
6. What is the difference between:
```terraform plan```
and:
```terraform plan -out=tfplan```
7. Why might a CI pipeline prefer:
```terraform apply tfplan```
rather than running:
```terraform apply```
after somebody has reviewed an earlier plan?

8. Why shouldn't tfplan normally be uploaded to a public artifact repository?
9. Write a validation rule that permits only:
```text
development
staging
production
```
for `var.environment`.

10. Write a validation rule requiring external_port to be between 1024 and 65535.
11. What is the conceptual difference between variable validation and a resource precondition?
12. Put these commands into the order you would normally expect in a CI validation job:
```powershell
terraform validate
terraform fmt -check
terraform plan
terraform init
```
==>
1. Check the configuration format
2. No
3. Validate syntax & configuration consistency
4. Yes
5. `terraform plan`
6. The second write the plan into `tfplan` file
7. Prefer the first option as apply will use the exact plan as has been reviewed
8. As plan may contain sensitive data (e.g. password, security token, etc.)
9. ```hcl
   validation {
    condition = contains (
        ["development", "staging", "production"],
        var.environment
    )

    error_message = "Environment should be one of development, staging or production"
   }
   ```
10. ```hcl
    validation {
      condition = (
        var.external_port >= 1024 && var.external_port <= 65535
      )

      error_message = "External port must be between 1024 & 65535"
    }
    ```
11. Variable validation check variable value, while resource precondition check assumption required by the resource
12. fmt -check > init > validate > plan

### Set 2