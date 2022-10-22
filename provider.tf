terraform {
  backend "s3" {
    bucket         = "fuzzy-couscous-backend-284739"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "fuzzy_couscous_table"
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