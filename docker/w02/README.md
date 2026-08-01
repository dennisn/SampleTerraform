# Week 02
- First, extract variable like environment, network name, web/cache image, web external ports
- Modify the configuration so it supports 2 environments: Development & testings
- *Optional*: replace the separate image variables with an object

## Questions to answer
- Does Terraform create a second set of containers, or rename/replace the existing containers?
- Why does changing environment affect several resources?
- Which references create dependencies on the Docker network?
- What is the difference between var.environment and local.resource_prefix?
- Why should passwords not be committed in terraform.tfvars?
- What value is selected when terraform.tfvars specifies port 8081, but the command includes:
  ```powershell
  -var="web_external_port=8082"
  ```