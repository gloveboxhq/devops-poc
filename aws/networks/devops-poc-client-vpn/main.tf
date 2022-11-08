# networks/devops-poc-client-vpn

provider "aws" {
  region = var.region
}

provider "awsutils" {
  region = var.region
}

locals {
  vars = yamldecode(file("${var.workspace}.yaml"))

  additional_routes = [for route in var.additional_routes : {
    destination_cidr_block = route.destination_cidr_block
    description            = route.description
    target_vpc_subnet_id   = element(module.subnets.private_subnet_ids, 0)
  }]
}

resource "random_password" "vpn_pass" {
  length    = 24
  min_upper = 6
  min_lower = 3
}

module "vpc_target" {
  source  = "cloudposse/vpc/aws"
  version = "0.21.1"

  cidr_block = local.vars.target_cidr_block

  context = module.this.context
}

module "secrets" {
  source  = "SweetOps/secretsmanager/aws"
  version = "0.1.0"

  secret_version = {
    enabled = true
    secret_string = jsonencode(
      {
        # vpn secrets
      }
    )
  }
  context = module.label.context
}

module "sg" {
  source = "cloudposse/security-group/aws"
  # Cloud Posse recommends pinning every module to a specific version
  version = "1.0.1"

  # Security Group names must be unique within a VPC.
  # This module follows Cloud Posse naming conventions and generates the name
  # based on the inputs to the null-label module, which means you cannot
  # reuse the label as-is for more than one security group in the VPC.
  #
  # Here we add an attribute to give the security group a unique name.
  attributes = ["primary"]

  # Allow unlimited egress
  allow_all_egress = true

  rules = [
    {
      key         = "client-vpn-endpoint"
      type        = "ingress"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      self        = true
      description = "Allow HTTP from inside the security group"
    }
  ]

  vpc_id  = module.vpc.vpc_id

  context = module.label.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.39.8"

  availability_zones   = local.vars.availability_zones
  vpc_id               = module.vpc_target.vpc_id
  igw_id               = module.vpc_target.igw_id
  cidr_block           = module.vpc_target.vpc_cidr_block
  nat_gateway_enabled  = true
  nat_instance_enabled = false
  context              = module.this.context
}

module "ec2_client_vpn" {
  source  = "cloudposse/ec2-client-vpn/aws"
  version = "0.13.0"

  ca_common_name     = local.vars.ca_common_name
  root_common_name   = local.vars.root_common_name
  server_common_name = local.vars.server_common_name

  client_cidr                   = local.vars.client_cidr_block
  organization_name             = local.vars.organization_name
  logging_enabled               = local.vars.logging_enabled
  logging_stream_name           = local.vars.logging_stream_name
  retention_in_days             = local.vars.retention_in_days
  associated_subnets            = module.subnets.private_subnet_ids
  authorization_rules           = local.vars.authorization_rules
  additional_routes             = local.additional_routes
  associated_security_group_ids = local.vars.associated_security_group_ids
  export_client_certificate     = local.vars.export_client_certificate
  vpc_id                        = module.vpc_target.vpc_id
  dns_servers                   = local.vars.dns_servers
  split_tunnel                  = local.vars.split_tunnel

  context = module.this.context
}
