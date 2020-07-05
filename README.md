# Terraform Playground
[![Build Status](https://travis-ci.org/joesustaric/tf-playground.svg?branch=master)](https://travis-ci.org/joesustaric/tf-playground)

Here lies a repository to construct an aws VPC with some TBD other resources..  
This is mostly as a self reference on how to do a these things but I also was to try some other stuff..

Trying to attempt...
- [ ] Following this randomly googled [tf best practices](https://github.com/ozbillwang/terraform-best-practices) list.
- [ ] Create a AWS VPC including multi AZ private and public subnets (basic setup)
- [ ] Bastion box to access VPC (maybe via [this?](https://aws.amazon.com/blogs/infrastructure-and-automation/toward-a-bastion-less-world/))
- [ ] ECS cluster / EKS setup / something with more complexity.
- [ ] Manage Iam roles.. perhaps via [iamy](https://github.com/99designs/iamy)
- [ ] Use [checkov](https://www.checkov.io/) to lock that down.
- [x] Get checkov running in a CI?
- [ ] Drift detection (aws moves from code, when aws moves from cf definition..)

Stretch...
- [ ] Also attempt similar as above but maybe for GCP..

## Using 
* [Terraform](https://www.terraform.io/)  
* [`aws-vault`](https://github.com/99designs/aws-vault) for local AWS credential managment 
* [chekov](https://github.com/bridgecrewio/checkov) 
* [`asdf`](https://github.com/asdf-vm/asdf)(optional) for version management

## Setup

1. Install Terraform. `brew install terraform`
2. Install Tab auto completion `terraform -install-autocomplete`
3. `terraform init`
4. install checkov `pip install checkov`

# TF Backend setup
Inside the `remote-state` there is terraform code which sets up an encrypted S3 bucket to hold then subsequent terraform state files, also a DynamoDB table to enable state locking so if two people attempt to update state at the same time it will error.  See https://www.terraform.io/docs/state/locking.html

This needs to be run first via 
```
terraform init
terraform apply
```

Yes this will create a locak tfstate file for this directory but it should only be needed to run once. (yeah chicken egg etc..)  

## WIP notes
`.tfstate` file is important.  
Do not commit to git (at least not in plain text) it can / will have sensitive information in it.  
Use remote state https://www.terraform.io/docs/state/remote.html , it can save to 
> Terraform Cloud, HashiCorp Consul, Amazon S3, Alibaba Cloud OSS, and more.`

See https://www.terraform.io/docs/backends/ how to configure.
This repo will use S3

