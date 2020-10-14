# Set up backend to store .tfstate file
# https://www.terraform.io/docs/backends/types/index.html
# https://www.terraform.io/docs/backends/types/s3.html

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    encrypt        = true
    bucket         = "joes-tf-state-encrypted"
    key            = "prod/ecs/terraform.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "tf-app-state"
  }
}

provider "aws" {
  # Don't commit AWS keys
  # You can use this type of AWS authentication at your own risk
  # access_key = var.aws_access_key_id
  # secret_key = var.aws_secret_access_key

  version = "~> 2.0"
  region  = var.region
}

# Reference another tfstate file to pluck out the output variables
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt = true
    bucket  = "joes-tf-state-encrypted"
    key     = "prod/vpc/terraform.tfstate"
    region  = var.region
  }
}
