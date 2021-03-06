#!/usr/bin/env bash

set -exo pipefail

export TF_VERSION=$(cat .version)
export PATH=$PATH:$(pwd)
export AWS_REGION=ap-southeast-2

wget --quiet "https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_"$TF_VERSION"_linux_amd64.zip"
unzip "terraform_"$TF_VERSION"_linux_amd64.zip"
rm "terraform_"$TF_VERSION"_linux_amd64.zip"

# TODO - Find a better dynamic way to traverse the definitions and run the checks
# rather than having to add them in here 1 by 1. 

# NAT Gateways cost $$ - create when using
# pushd prod/vpc
# terraform init
# terraform plan -var-file=prod-vpc.tfvars -detailed-exitcode
# popd

# pushd prod/ecs
# terraform init
# terraform plan -var-file=prod-ecs.tfvars -detailed-exitcode
# popd

pushd prod/foo-app
terraform init
terraform plan -var-file=prod.tfvars -detailed-exitcode
popd
