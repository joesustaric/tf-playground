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
- [x] Drift detection (aws moves from code, when aws moves from cf definition..)
    - [ ] Make script more dynamic for checks.
- [x] How to manage secrets eg private key / db password
- [ ] ECS cluster / EKS setup / something with more complexity.
    - [ ] wip - [ecs maybe](http://blog.shippable.com/setup-a-container-cluster-on-aws-with-terraform-part-2-provision-a-cluster)
- [ ] Set up a simple app to be deployed to the ecs cluster. (Golang API)
- [ ] Bastion box to access EC2 instance (maybe via [this?](https://aws.amazon.com/blogs/infrastructure-and-automation/toward-a-bastion-less-world/))
- [ ] Play with [awsspec](https://github.com/k1LoW/awspec) see if its any good

Stretch...
- [ ] Also attempt similar as above but maybe for GCP?..
- [ ] Check out [Terratest](https://terratest.gruntwork.io/)
- [ ] Mebbe https://docs.aws.amazon.com/cdk/latest/guide/home.html ?

Fix Later..
- [ ] IAM for travis CI user..
- [ ] Parallel checks

## Tools 🔩
* [`Terraform`](https://www.terraform.io/) IaC Tool.
* [`aws-vault`](https://github.com/99designs/aws-vault) for local AWS credential managment (optional).
* [`chekov`](https://github.com/bridgecrewio/checkov) Static Code analysis tool for IaC.
* [`iamy`](https://github.com/99designs/iamy) AWS IAM configuration into YAML files.
* [`asdf`](https://github.com/asdf-vm/asdf) for Terraform version management (optional).
* [`Travis CI`](https://www.travis-ci.com)

## Install the Tools ⚒
1. Install stuff `brew install terraform iamy travis` (If you're not on a mac figure it out..soz) check the `.version` file for the right version of Terraform.
1a. Install Tab auto completion `terraform -install-autocomplete`
2. install checkov `pip install checkov`

## Repo Structure 🏛
- [ ] TODO - explain directory structure.
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
└── stage
 ```

## CI Setup ♻️
Using Travis CI. 
There is a Travis CI user in the IAM config.
Encrypting Environment Variables via the [Travis CLI tool](https://docs.travis-ci.com/user/environment-variables/#encrypting-environment-variables)..

```bash
travis encrypt MY_SECRET_ENV=super_secret --add env.global
```

## Terraform Backend Setup 🍑
Inside the `remote-state` there is terraform code which sets up an encrypted S3 bucket to hold the  Terraform state files. Also a DynamoDB table to enable [state locking](https://www.terraform.io/docs/state/locking.html).

Run this first..
```bash
terraform init
terraform apply
```
More [info](https://www.terraform.io/docs/backends/).

Yes this will create a local `.tfstate` file but it should only be needed to run once. (yeah chicken egg etc..)  

## How to Manage Secrets
### AWS
Using AWS Secrets Manager to hold secrets. 
Refer to [this](https://blog.gruntwork.io/a-comprehensive-guide-to-managing-secrets-in-your-terraform-code-1d586955ace1#bebe) on how to add a secret.  
There should be clear access roles also defined about who can access these secrets.
- [ ] TODO Create a clear way to assign users permission to access and modify secrets.

## Helpful sites refrenced 
https://blog.gruntwork.io/how-to-create-reusable-infrastructure-with-terraform-modules-25526d65f73d#ff91  


## Notes
`.tfstate` file is super important.  
Do not commit to git (at least not in plain text) it can / will have sensitive information in it.  
Use remote state https://www.terraform.io/docs/state/remote.html , it can save to 
> Terraform Cloud, HashiCorp Consul, Amazon S3, Alibaba Cloud OSS, and more.`

#### AWS Stack vs Terraform Modules
TF has a state file (`.tfstate`). Terraform uses this to map real world resources to your configuration, keep track of metadata, and to improve performance for large infrastructures. 
It will refresh itself prior to any operation.

This is a giant dependancy graph. It uses this to optimise performance on `terraform plan` executions and other processing work. More info [here](https://www.terraform.io/docs/state/purpose.html).

The only way you can create AWS CF stacks is via [this](https://www.terraform.io/docs/providers/aws/r/cloudformation_stack.html). But it appears that this isn't something that is used often when writing TF. You seem to have to paste in the CF directly.

Terraform has a concept of [modules](https://www.terraform.io/docs/modules/index.html) which is a container for multiple resources that are used together. This helps mainly with reusability. 

