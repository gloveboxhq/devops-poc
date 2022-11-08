# databases/devops-poc-postgres
# database secrets
resource "random_password" "rds_pass" {
  length    = 24
  special   = false
  min_lower = 3
  min_upper = 3
}

module "secrets" {
  source  = "SweetOps/secretsmanager/aws"
  version = "0.1.0"

  secret_version = {
    enabled = true
    secret_string = jsonencode(
      {
        ssh_public_key  = base64encode(module.ssh_key_pair.public_key)
        ssh_private_key = base64encode(module.ssh_key_pair.private_key)
      }
    )
  }
  context = module.label.context
}
