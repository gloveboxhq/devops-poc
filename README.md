# DevOps POC

For this challenge we're looking for an infrastructure as code (IaC) solution on Amazon Web Services (AWS) which achieves the following:

- [ ] Configures Org level SSO. 
	- [ ] Create an Admin role. 
	- [ ] Create a Database Analyst role. 
- [ ] Configures a Client VPN that leverages the org level SSO for managing access to the infrastructure.
- [ ] Configures AWS RDS Postgres 14+ instance that leverages IAM for access control to the database.
	- [ ] Configure a read replica of the Postgres instance.
	- [ ] Grant the Database Analyst access to the read replica, but not the primary.
- [ ] Configure GitHub Actions to validate the configuration. 

## Submission

To work on this project, please fork this repository, create a new branch and start working on your changes. Once you have code to submit send in a PR to this repository to initiate code review.

## Tooling

We're looking for you to leverage one of the following tools for this challenge:

* [HashiCorp Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
* [Amazon CDK](https://aws.amazon.com/cdk/)

