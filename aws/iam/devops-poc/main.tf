locals {
  vars = yamldecode(file("${var.workspace}.yaml"))
  enabled = module.this.enabled
}

provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "devops-poc-postgres-arn" {
  name = "${locals.var.stage}-devops-poc-postgres-arn"
}

data "aws_iam_policy_document" "dev-devops-poc-data-analyst-policy" {
  count = local.enabled ? 1 : 0

  statement {
    sid       = "FullAccess"
    effect    = "Allow"
    resources = ["${module.bucket.bucket_arn}/*"]

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "base" {
  count = local.enabled ? 1 : 0

  statement {
    sid    = "BaseAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:ListBucketVersions"
    ]

    resources = [
      module.bucket.bucket_arn
    ]
  }
}

module "role" {
  version = "0.17.0"

  principals   = var.principals
  use_fullname = var.use_fullname

  policy_documents = [
    join("", data.aws_iam_policy_document.resource_full_access.*.json),
    join("", data.aws_iam_policy_document.base.*.json),
  ]

  policy_document_count = 2
  policy_description    = "Test IAM policy"
  role_description      = "Test IAM role"

  context = module.this.context
}
