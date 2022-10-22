resource "aws_kms_key" "rds_encryption_key" {
    description = "challenge rds db key"
}

resource "aws_secretsmanager_secret" "rds-secret" {
    name = "rds-secret"
}

resource "aws_secretsmanager_secret_version" "rds-password" {
    secret_id = aws_secretsmanager_secret.rds-secret.id
    secret_string = var.rds_supersecretpassword
}