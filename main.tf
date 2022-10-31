/*
This is the root module for the Terraform proof of concept challenge. In this 
module, there are five modules that contain the code for this challenge. They
are primarily broken down into logical groupings according to function as 
described. 
*/

/*
The networking module contains the required networking pieces of the build. 
It contains the following: Security groups for RDS access and VPN access, 
a certificate for the AWS ACM service, a client vpn endpoint, along with the
association and rules for the client endpoint. 
*/

module "networking" {
  source                = "./modules/networking"
  directory_arn         = module.iam.corp-domain-name.id
  directory_service_ips = module.iam.corp-domain-name.dns_ip_addresses
  vpc_id                = module.data.vpc_data.id
  vpc_cidr              = module.data.vpc_data.cidr_block
  subnet_ids            = module.data.default_subnets.ids
  domain_name           = module.iam.corp-domain-name.name
  vpn_password          = module.encryption.vpn-password
}

/*
the "data" module provides a central location for all data that either currently
resides in AWS (namely the default vpc and the managed iam policies) or it contains
configurations for creating passwords for RDS, directory service, or the vpn. 
*/

module "data" {
  source = "./modules/data"
}

/*
The IAM module contains IAM related resources such as IAM policies, policy 
attachments, the directory service that provides resources to the VPN endpoint, 
and creating the rds analyst and administrator roles that the challenge required
*/

module "iam" {
  source           = "./modules/iam"
  analyst_policy   = module.data.rds_analyst_policy.arn
  admin_policy     = module.data.admin_policy.arn
  read-replica-arn = module.database.rds_read_replica.arn
  directory-secret = module.encryption.directory-password
  vpc_id           = module.data.vpc_data.id
  subnet_ids       = module.data.default_subnets.ids
  account_id       = module.data.account_id
  user_arn         = module.data.caller_arn
  rds_id           = module.database.rds_read_replica.resource_id
}

/*
this database module contains RDS related resources and configurations. 
It creates a PostgreSQL database with the required attributes (version 14+), 
as well as a read replica. Backups of the DB are taken every monday morning. 
The DB is encrypted using a KMS key stored in KMS. The password for the user
is generated in the data module and stored in AWS Secrets Manager.
*/

module "database" {
  source        = "./modules/database"
  kms_key       = module.encryption.rds-key.arn
  rds_sg        = module.networking.rds-sg.id
  rds-secret    = module.encryption.rds-password
  rds-root-user = module.data.rdsrootuser.id

}
/*
While this next module is named "encryption", it's a bit misleading because 
it contains the encryption key, but also it references and stores the generated
passwords from the data module into AWS Secrets manager. It creates the required
metadata and then stores the latest version into the secrets manager.
*/

module "encryption" {
  source                        = "./modules/encryption"
  rds_supersecretpassword       = module.data.rdspassword.result
  vpn_supersecretpassword       = module.data.vpn_password.result
  directory_supersecretpassword = module.data.directory_password.result
  secret-id                     = module.data.random_integer.result
  directory_domain              = module.iam.corp-domain-name.name
}