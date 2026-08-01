# Week 1

Extend the configuration so that it creates:
- One Docker network named terraform-network
- One Nginx container
- One Redis container
- Both containers attached to the same network
- Nginx exposed on port 8080
- Redis not exposed to the host

## Prepare
Before applying, predict:
- How many resources Terraform will create ? --> 5
- Which dependencies Terraform will infer ? --> `terraform graph`
- Which resources can be created concurrently ? --> image & network, web & cache
- What will happen when you run terraform apply twice ? --> nothing change (except for fixing drift)


## Knowledge check
Answer these before proceeding to Week 2:
- What is the difference between a provider and a resource?
- Why should .terraform.lock.hcl normally be committed?
- What information does Terraform state contain?
- How does Terraform infer that the container depends on the image?
- What does terraform plan compare?
- What is configuration drift?
- Why might changing a resource property cause replacement rather than an in-place update?