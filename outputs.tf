
# These outputs were mostly for validation purposes


output "read-replica-arn" {
  value = module.database.rds_read_replica.arn
}

output "vpc_info" {
  value = module.data.vpc_data
}

output "subnets" {
  value = module.data.default_subnets.ids
}

output "ds_ips" {
  value = module.iam.corp-domain-name.dns_ip_addresses
}