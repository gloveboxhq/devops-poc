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
    length = 16
    special = true
    min_lower = 3
    min_upper = 3
    min_special = 3
}