module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  name                         = var.vpc_name
  cidr                         = var.cidr_block
  azs                          = var.azs
  private_subnets              = var.private_sn
  public_subnets               = var.public_sn
  create_igw                   = true
  single_nat_gateway           = true
}