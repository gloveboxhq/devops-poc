data "aws_availability_zones" "zones" {}

## Managed RDS Read-Only Policy
data "aws_iam_policy" "rds_read_only_policy" {
    arn = "arn:aws:iam::aws:policy/AmazonRDSReadOnlyAccess"
}

## Managed AdministratorAccess Policy
data "aws_iam_policy" "administrator_access" {
    arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "random_password" "rds-password" {
    length = 24
    special = false
    min_lower = 3
    min_upper = 3
}

resource "random_pet" "rds-root-user" {
    length = 1
}

resource "random_integer" "secret-id" {
    min = 10
    max = 20
}