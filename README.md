# About
Just me messing around with TF

I want to attempt...

- [ ] Create a AWS VPC including multi AZ private and public subnets
- [ ] Bastion box to access VPC
- [ ] ECS cluster
- [ ] Get checkov running in a CI?
.. maybe more.


Also attempt similar as above but maybe for GCP..

Also Playing with https://www.checkov.io/  
install `pip install checkov`

This also uses `asdf-vm` for version management.

## Using 
terraform  
aws-vault  
chekov

## Setup

1. Install Terraform. `brew install terraform`
2. Tab auto completion `terraform -install-autocomplete`
3. install checkov `pip install checkov`


## Terraform Setup
`terraform init`


## WIP notes
`.tfstate` file is important.  
Do not commit to git (at least not in plain text) it can / will have sensitive information in it.  
Use remote state https://www.terraform.io/docs/state/remote.html , it can save to 
> Terraform Cloud, HashiCorp Consul, Amazon S3, Alibaba Cloud OSS, and more.`

See https://www.terraform.io/docs/backends/ how to configure.
This repo will use S3

TODO : use partial config to separate secrets. https://www.terraform.io/docs/backends/config.html#partial-configuration (can use `kms_key_id` to encrypt it on s3)

