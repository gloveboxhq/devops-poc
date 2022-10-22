/* 
the first two resources create the rds analyst role and attaches the 
managed RDS Read Only Policy
*/

resource "aws_iam_role" "rds_analyst_role" {
  name = "rds-analyst-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS": "arn:aws:iam::959867141488:user/MatthewDavis"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_analyst_attachment" {
    role = aws_iam_role.rds_analyst_role.name
    policy_arn = var.analyst_policy
}

/* 
these next two resources creates the admin role and attaches the 
managed Adminstrator policy
*/

resource "aws_iam_role" "admin_role" {
  name = "admin-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          "AWS": "arn:aws:iam::959867141488:user/MatthewDavis"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_attachment" {
    role = aws_iam_role.admin_role.name
    policy_arn = var.admin_policy
}