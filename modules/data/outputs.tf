output "az_names" {
  value = data.aws_availability_zones.zones
}

output "rds_analyst_policy" {
  value = data.aws_iam_policy.rds_read_only_policy
}

output "admin_policy" {
  value = data.aws_iam_policy.administrator_access
}
output "rdspassword" {
  value = random_password.rds-password
}

output "rdsrootuser" {
  value = random_pet.rds-root-user
}

output "random_integer" {
  value = random_integer.secret-id
}

output "directory_password" {
  value = random_password.directory-password
}

output "vpc_data" {
  value = data.aws_vpc.default
}

output "default_subnets" {
  value = data.aws_subnets.default
}

output "vpn_password" {
  value = random_password.directory-password
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}
