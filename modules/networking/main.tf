module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
  name                         = var.vpc_name
  cidr                         = var.cidr_block
  azs                          = var.azs
  private_subnets              = var.private_sn
  public_subnets               = var.public_sn
  create_igw                   = true
  single_nat_gateway           = true
  create_database_subnet_group = true
}

resource "aws_security_group" "postgres_db_sg" {
    name = "postgresql_sg"
    description = "Security Group for PostgreSQL DB"
    vpc_id = module.vpc.vpc_id 

    ingress {
        from_port = 5432
        to_port   = 5432
        protocol  = "tcp"
        ##update to new subnet group cidr when created
        cidr_blocks = ["0.0.0.0/0"]
    }

}