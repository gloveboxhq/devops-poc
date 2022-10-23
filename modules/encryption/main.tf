resource "aws_kms_key" "rds_encryption_key" {
  description = "challenge rds db key"
}

## the next three resources store the generated password in Secrets manager
resource "aws_secretsmanager_secret" "rds-secret" {
  name = "rds-secret-${var.secret-id}"
}

resource "aws_secretsmanager_secret_version" "rds-password" {
  secret_id     = aws_secretsmanager_secret.rds-secret.id
  secret_string = var.rds_supersecretpassword
}

data "aws_secretsmanager_secret_version" "rds-password" {
  secret_id  = aws_secretsmanager_secret.rds-secret.id
  depends_on = [aws_secretsmanager_secret_version.rds-password]
}

## these resources store the directory service admin password in secrets manager

resource "aws_secretsmanager_secret" "directory-secret" {
  name = "directory-secret-${var.secret-id}"
}

resource "aws_secretsmanager_secret_version" "directory-password" {
  secret_id     = aws_secretsmanager_secret.directory-secret.id
  secret_string = var.directory_supersecretpassword
}

data "aws_secretsmanager_secret_version" "directory-password" {
  secret_id  = aws_secretsmanager_secret.directory-secret.id
  depends_on = [aws_secretsmanager_secret_version.directory-password]
}

## creating acm certificates for vpn connection

