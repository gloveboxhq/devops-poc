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