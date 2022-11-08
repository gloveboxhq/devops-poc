terraform {
  # backend "s3" {
  #  bucket = "dev-devops-poc"
  #  key    = "usw2/postgres/terraform.tfstate"
  #  region = "us-west-2"
  # }
  
  required_version = "1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.38.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.0"
    }
  }
}
