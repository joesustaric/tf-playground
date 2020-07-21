# Terraform Playground 🤾‍♂️
[![Build Status](https://travis-ci.org/joesustaric/tf-playground.svg?branch=master)](https://travis-ci.org/joesustaric/tf-playground)

Here lies a repository to construct an aws VPC with some other TBD resources..  
This is mostly as a self reference on how to do a these things, but also an example of how to run some form of decent CI with Infrastructure as Code tools..
Trying to follow this randomly googled [tf best practices](https://github.com/ozbillwang/terraform-best-practices) list as well.. 

Lets try to attempt...
- [x] Create a AWS VPC including multi AZ private and public subnets (basic setup)
- [x] Use [checkov](https://www.checkov.io/) to lock that down.
- [x] Get checkov running in a CI
- [x] Manage IAM roles.. via [iamy](https://github.com/99designs/iamy)
- [x] Get IAM role sync checks working in CI
- [ ] Drift detection (aws moves from code, when aws moves from cf definition..)
- [ ] ECS cluster / EKS setup / something with more complexity.
- [ ] Bastion box to access VPC (maybe via [this?](https://aws.amazon.com/blogs/infrastructure-and-automation/toward-a-bastion-less-world/))
- [ ] Play with [awsspec](https://github.com/k1LoW/awspec) see if its any good

Stretch...
- [ ] Also attempt similar as above but maybe for GCP?..
- [ ] Mebbe https://docs.aws.amazon.com/cdk/latest/guide/home.html ?

## Tools 🔩
* [`Terraform`](https://www.terraform.io/) IoC Tool.
* [`aws-vault`](https://github.com/99designs/aws-vault) for local AWS credential managment (optional).
* [`chekov`](https://github.com/bridgecrewio/checkov) Static Code analysis tool for IaC.
* [`iamy`](https://github.com/99designs/iamy) AWS IAM configuration into YAML files.
* [`asdf`](https://github.com/asdf-vm/asdf) for Terraform version management (optional).
* [`Travis CI`](https://www.travis-ci.com)

## Install the Tools ⚒
1. Install stuff `brew install terraform iamy travis` (If you're not on a mac figure it out..soz) 
1a. Install Tab auto completion `terraform -install-autocomplete`
2. install checkov `pip install checkov`

## Repo Structure 🏛
 ```
├── README.md
├── global
│   ├── IAM
│   └── s3
├── mgmt
├── modules
│   └── vpc
├── prod
│   └── vpc
├── scripts
│   └── check.sh
└── stage
 ```

## CI Setup ♻️
Using Travis CI. 
There is a Travis CI user in the IAM config, which can assume the 
Encrypting Environment Variables via the [Travis CLI tool](https://docs.travis-ci.com/user/environment-variables/#encrypting-environment-variables)..

```bash
travis encrypt MY_SECRET_ENV=super_secret --add env.global
```

- TODO
- [ ] Enable Drift detection.
> Drift is the term for when the real-world state of your infrastructure differs from the state defined in your configuration

## Terraform Backend Setup 🍑
Inside the `remote-state` there is terraform code which sets up an encrypted S3 bucket to hold the  Terraform state files. Also a DynamoDB table to enable [state locking](https://www.terraform.io/docs/state/locking.html).

Run this first..
```bash
terraform init
terraform apply
```
More [info](https://www.terraform.io/docs/backends/).

Yes this will create a local `.tfstate` file but it should only be needed to run once. (yeah chicken egg etc..)  

## Notes
`.tfstate` file is super important.  
Do not commit to git (at least not in plain text) it can / will have sensitive information in it.  
Use remote state https://www.terraform.io/docs/state/remote.html , it can save to 
> Terraform Cloud, HashiCorp Consul, Amazon S3, Alibaba Cloud OSS, and more.`

#### AWS Stack vs Terraform Modules
TF has a state file (`.tfstate`). Terraform uses this to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. 
It will refresh itself prior to any operation.

This is a giant dependancy graph. It uses this to optimise performance on `terraform plan` executions and other processing work. More info [here](https://www.terraform.io/docs/state/purpose.html).

Looks like you can create stacks in Terraform via [this](https://www.terraform.io/docs/providers/aws/r/cloudformation_stack.html). Although Terraform has a concept of [modules](https://www.terraform.io/docs/modules/index.html) which is a container for multiple resources that are used together. This helps mainly with reusability. 

