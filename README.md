# glovebox/devops-poc

Usual pattern is to put this somewhere like:

<org>/<service or monorepo>/aws/
<org>/<service or monorepo>/.github/workflows

Targeting environments requires creating `dev`, `staging`, `prod` workspaces:

`envs=(dev staging prod); for env in "${envs[@]}"; do $HOME/bin/terraform workspace new "$env"; done`

Resources are defined as their own units of work. New pattern, still breaking it in, 
but the goal is self-contained resources to improve re-use. TF microservices, not monoliths ;)

Leaning on the smart people at Cloudposse to keep an eye on Terraform patterns, smooth rough edges, 
abstract away extra syntax. As with AWS, I can never know all of Terraform, and need help finding 
patterns to work with it efficiently.

YAML settings for devs to adjust quickly. YAML is a common "config language" for better or worse,
keep it familiar. Every language can read/write it making it easy to work with in tooling.

The Github Action runs against `develop` to keep the machine validating config,
highlight new issues sooner than later. Run plan often to avoid blocking
at the wrong time.

## Example usage

        terraform -chdir=$HOME/path/to/aws/databases/devops-poc-postgres init

        terraform -chdir=$HOME/path/to/aws/databases/devops-poc-postgres plan

        terraform -chdir=$HOME/path/to/aws/databases/devops-poc-postgres apply

## Ideas to expand on this

Setup S3 for Terraform state

Script install and configuration of local VPN client

Script to run each path, or some sequence of paths. Could be TF or simple shell command:

`tf_dirs=(one two three); for dir in "${dirs[@]}"; do terraform chdir="$dir" plan; done`

Scripts for local setup of AWS credentials, session login/management, get 
account IDs, resources permissions allow access to.
