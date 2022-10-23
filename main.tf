module "networking" {
  source = "./modules/networking"
  directory_arn = module.iam.corp-domain-name.id
  directory_service_ips = module.iam.corp-domain-name.dns_ip_addresses
  acm_cert = aws_acm_certificate.cert.arn
  vpc_id = module.data.vpc_data.id
  #azs = module.data.az_names.names 
}

module "data" {
    source = "./modules/data"
}

module "iam" {
    source = "./modules/iam"
    analyst_policy = module.data.rds_analyst_policy.arn
    admin_policy = module.data.admin_policy.arn
    read-replica-arn = module.database.rds_read_replica.arn
    directory-secret = module.encryption.directory-password
    vpc_id = module.data.vpc_data.id
    subnet_ids = module.data.default_subnets.ids
}


module "database" {
    source = "./modules/database"
    kms_key = module.encryption.rds-key.arn
    rds_sg = module.networking.rds-sg.id
    rds-secret = module.encryption.rds-password
    rds-root-user = module.data.rdsrootuser.id

}


module "encryption" {
    source = "./modules/encryption"
    rds_supersecretpassword = module.data.rdspassword.result
    secret-id = module.data.random_integer.result
    directory_supersecretpassword = module.data.directory_password.result
    directory_domain = var.directory-domain-name
}

# for importing the created acm certificate
resource "aws_acm_certificate" "cert" {
    private_key = "unknown" 
    certificate_body = "unknown" 
    
}