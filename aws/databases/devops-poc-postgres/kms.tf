# databases/devops-poc-postgres/kms.tf
# db encryption key
module "kms_key" {
  source = "cloudposse/kms-key/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "0.12.1"
  namespace               = local.vars.namespace
  stage                   = local.vars.stage
  name                    = local.vars.name
  description             = local.vars.description
  deletion_window_in_days = 7
  enable_key_rotation     = false

  context = module.this.context
}
