data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${local.vars.stage}/private_subnet_ids"
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.aws_ssm_parameter.vpc_id]
  }
}

data "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${local.vars.stage}/public_subnet_ids"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "/${local.vars.stage}/vpc_id"
}

data "aws_vpc" "this" {
  id = data.aws_ssm_parameter.vpc_id.value
}

data "aws_ssm_parameter" "rds_pass" {
  name = "/${local.vars.stage}/rds_pass"
}
