# Week 02
- First, extract variable like environment, network name, web/cache image, web external ports
- Modify the configuration so it supports 2 environments: Development & testings
- *Optional*: replace the separate image variables with an object

## Questions to answer
1. Does Terraform create a second set of containers, or rename/replace the existing containers?
2. Why does changing environment affect several resources?
3. Which references create dependencies on the Docker network?
4. What is the difference between var.environment and local.resource_prefix?
5. Why should passwords not be committed in terraform.tfvars?
6. What value is selected when terraform.tfvars specifies port 8081, but the command includes:
   ```powershell
   -var="web_external_port=8082"
   ```
==>
1. replace the existing containers
2. because the prefix changed
3. the resource reference inside `network_advanced`
4. `var.environment`: external supplied environment value, while `local.resource_prefix` is calculated from `var.environment`
5. For security reason: Passwords should not be committed because Git preserves their history. Removing a secret in a later commit does not reliably remove it from previous commits. Also, marking a variable as sensitive only hides it from normal CLI output. The value may still be stored in Terraform state.
6. "8082" will be selected