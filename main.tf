module "networking" {
  source = "./modules/networking"
  azs = module.data.az_names.names 
}

module "data" {
    source = "./modules/data"
}

module "iam" {
    source = "./modules/iam"
    analyst_policy = module.data.rds_analyst_policy.arn
    admin_policy = module.data.admin_policy.arn
}

/*
module "database" {
    source = "./modules/database"
    kms_key = module.encryption.rds-key.arn
    rds_sg = module.networking.rds-sg.id
}
*/

module "encryption" {
    source = "./modules/encryption"
    rds_supersecretpassword = module.data.rdspassword.result
}