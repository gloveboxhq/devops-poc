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