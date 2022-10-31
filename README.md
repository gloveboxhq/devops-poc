# DevOps POC

For this challenge we're looking for an infrastructure as code (IaC) solution on Amazon Web Services (AWS) which achieves the following:

- [X] Configures Org level SSO. 
	- [X] Create an Admin role. 
	- [X] Create a Database Analyst role. 
- [X] Configures a Client VPN that leverages the org level SSO for managing access to the infrastructure.
- [X] Configures AWS RDS Postgres 14+ instance that leverages IAM for access control to the database.
	- [X] Configure a read replica of the Postgres instance.
	- [X] Grant the Database Analyst access to the read replica, but not the primary.
- [X] Configure GitHub Actions to validate the configuration. 

## Submission

To work on this project, please fork this repository, create a new branch and start working on your changes. Once you have code to submit send in a PR to this repository to initiate code review.

## Tooling

We're looking for you to leverage one of the following tools for this challenge:

* [HashiCorp Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Amazon CDK](https://aws.amazon.com/cdk/)


## Project Notes: 
This is primarily run through my own Terraform Cloud workspace and organization. I did this becaue it was easier for me to integrate Github Actions workflow through Terraform Cloud. Resources in AWS will be created in 
us-east-1. 

To use this project, a Terraform workspace will have to be setup and configured. In the `provider.tf` file, the following areas will need to be updated: the **workspace** and the **organization**. These areas are annoted in the file comments. Next, repository settings and secrets will have to be configured. An API key will need to be generated on Terraform Cloud and it should be named **TF_API_KEY**. This should be copied into the Github repository as a respository secret. Since there are no hard-coded credentials written in this Terraform code, AWS credentials will have to be configured as secrets within the Terraform workspace settings as environment variables. Specifically, the variables should be named **AWS_ACCESS_KEY_ID** and **AWS_SECRET_ACCESS_KEY**

Once this is configured, before executing the code, you must be logged into Terraform. This can be started by executing `terraform init` from the terminal. It will prompt the user to create an API key that can log the user into the service (note that this will be different than the TF_API_KEY that was generated earlier). This API key will be used at the terminal which will complete the login process and initialize terraform. From this point, the user can execute `terraform validate` to validate the code, then finally `terraform plan` to plan the build, and finally `terraform apply` to execute the build. 
