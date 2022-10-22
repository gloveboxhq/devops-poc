output "rds-key" {
    value = aws_kms_key.rds_encryption_key
}
output "rds-password" {
  value = jsonencode(data.aws_secretsmanager_secret_version.rds-password.secret_string)
}