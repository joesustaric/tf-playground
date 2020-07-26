#!/usr/bin/env bash

set -xo pipefail

export TF_VERSION=$(cat .version)

wget "https://releases.hashicorp.com/terraform/0.11.3/terraform_$TF_VERSION_linux_amd64.zip"
unzip terraform_$TF_VERSION_linux_amd64.zip
mv terraform /usr/bin
m terraform_0.11.3_linux_amd64.zip

# terraform plan -var-file=prod.tfvars -detailed-exitcode