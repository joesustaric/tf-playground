#!/usr/bin/env bash

set -xo pipefail

export TF_VERSION=$(cat .version)
export PATH=$PATH:$(pwd)

wget --quiet "https://releases.hashicorp.com/terraform/$TF_VERSION/terraform_"$TF_VERSION"_linux_amd64.zip"
unzip "terraform_"$TF_VERSION"_linux_amd64.zip"
rm "terraform_"$TF_VERSION"_linux_amd64.zip"

cd prod/vpc
terraform plan -var-file=prod.tfvars -detailed-exitcode
