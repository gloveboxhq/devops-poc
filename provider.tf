
terraform {
  cloud {
    organization = "friends_of_fate_903"

    workspaces {
      name = "challenge_workspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}




provider "aws" {
  region                   = var.region
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
  profile                  = "default"

  default_tags {
    tags = {
      environment = "test"
      function    = "devOpsChallenge"
    }
  }
}