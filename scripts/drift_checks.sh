#!/usr/bin/env bash

set -xo pipefail

export TF_VERSION=$(cat .version)

wget https://releases.hashicorp.com/terraform/$(TF_VERSION)/terraform_$(TF_VERSION)_linux_amd64.zip
unzip terraform_$(TF_VERSION)_linux_amd64.zip
mv terraform /usr/bin
rm terraform_$(TF_VERSION)_linux_amd64.zip

terraform

# terraform plan -var-file=prod.tfvars -detailed-exitcode