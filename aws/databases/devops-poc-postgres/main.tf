locals {
  vars = yamldecode(file("${var.workspace}.yaml"))
}

provider "aws" {
  region = local.vars.region
}

module "rds_cluster" {
  source                               = "cloudposse/rds-cluster/aws"
  version                              = "1.3.2"
  engine                               = local.vars.engine
  engine_mode                          = local.vars.engine_mode
  cluster_family                       = local.vars.cluster_family
  cluster_size                         = local.vars.cluster_size
  admin_user                           = local.vars.admin_user
  admin_password                       = local.vars.admin_password
  db_name                              = local.vars.db_name
  instance_type                        = local.vars.instance_type
  vpc_id                               = module.vpc.vpc_id
  subnets                              = module.subnets.private_subnet_ids
  security_groups                      = [module.vpc.vpc_default_security_group_id]
  deletion_protection                  = local.vars.deletion_protection
  autoscaling_enabled                  = local.vars.autoscaling_enabled
  storage_type                         = local.vars.storage_type
  iops                                 = local.vars.iops
  allocated_storage                    = local.vars.allocated_storage
  intra_security_group_traffic_enabled = local.vars.intra_security_group_traffic_enabled

  cluster_parameters = [
    {
      name         = "character_set_client"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_connection"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_database"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_results"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "character_set_server"
      value        = "utf8"
      apply_method = "pending-reboot"
    },
    {
      name         = "collation_connection"
      value        = "utf8_bin"
      apply_method = "pending-reboot"
    },
    {
      name         = "collation_server"
      value        = "utf8_bin"
      apply_method = "pending-reboot"
    },
    {
      name         = "lower_case_table_names"
      value        = "1"
      apply_method = "pending-reboot"
    },
    {
      name         = "skip-character-set-client-handshake"
      value        = "1"
      apply_method = "pending-reboot"
    }
  ]

  context = module.this.context
}
