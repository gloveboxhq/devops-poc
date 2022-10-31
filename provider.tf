## requires terraform cloud login & aws access keys
terraform {
  cloud {
    # change the line below to your own organization to run the build
    organization = "friends_of_fate_903"
    # change the line below to your own workspace to run the build
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


/* the credential below info can be removed if running in a workflow
*/

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