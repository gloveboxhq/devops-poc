/* 
the first two resources create the rds analyst role and attaches the 
managed RDS Read Only Policy
*/

resource "aws_iam_role" "rds_analyst_role" {
  name = "rdsanalyst"

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
          "AWS" : "${var.user_arn}"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_analyst_attachment" {
  role       = aws_iam_role.rds_analyst_role.name
  policy_arn = aws_iam_policy.readerdbpolicy.arn
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
          "AWS" : "${var.user_arn}"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_attachment" {
  role       = aws_iam_role.admin_role.name
  policy_arn = var.admin_policy
}

resource "aws_iam_policy" "readerdbpolicy" {
  name        = "read_replica_policy"
  description = "policy to limit users to RDS read replica"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
            "Action": [
                "rds:Describe*",
                "rds:ListTagsForResource",
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeInternetGateways",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcAttribute",
                "ec2:DescribeVpcs"
            ],
      "Effect": "Allow",
      "Resource": "${var.read-replica-arn}"
    },
    {
            "Action": [
                "cloudwatch:GetMetricStatistics",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents"
            ],
      "Effect": "Allow",
      "Resource": "${var.read-replica-arn}"
    }
  ]

}
EOT
}

## the next two resources create and attach the rds iam auth policy to 
## the rdsanalyst role

resource "aws_iam_policy" "rds_iam_auth" {
  name        = "rds_iam_auth"
  description = "rds_iam_auth"

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "rds-db:connect"
      ],
      "Resource": [
        "arn:aws:rds-db:us-east-1:"${var.account_id}":dbuser:"${var.rds_id}/rdsanalyst"
      ]
    }
  ]
}
EOT
}

resource "aws_iam_role_policy_attachment" "rds_iam_auth" {
  role       = aws_iam_role.rds_analyst_role.name
  policy_arn = aws_iam_policy.rds_iam_auth.arn
}

## creates and attaches the vpn policy for the rdsanalyst role

resource "aws_iam_policy" "vpn_policy" {
  name        = "vpn_policy"
  description = "vpn policy"

  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeClientVpnRoutes",
                "ec2:DescribeClientVpnAuthorizationRules",
                "ec2:DescribeClientVpnConnections",
                "ec2:DescribeClientVpnTargetNetworks",
                "ec2:DescribeClientVpnEndpoints"
            ],
            "Resource": "*"
        }
    ]
}
EOT
}

resource "aws_iam_role_policy_attachment" "vpn_rds_attachment" {
  role = aws_iam_role.rds_analyst_role.name
  #policy_arn = var.analyst_policy
  policy_arn = aws_iam_policy.vpn_policy.arn
}


## this creates the simple directory service to aid the client vpn


resource "aws_directory_service_directory" "bar" {
  name     = var.directory-domain
  password = var.directory-secret
  size     = "Small"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = [var.subnet_ids[1], var.subnet_ids[2]]
  }
}
