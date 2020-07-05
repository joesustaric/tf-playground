# Set up backend to store .tfstate file
# https://www.terraform.io/docs/backends/types/index.html
# https://www.terraform.io/docs/backends/types/s3.html

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    encrypt = true
  }
}
# can I move the above elsewhere?

# Setup our aws provider
provider "aws" {
  # Don't commit keys, I have for testing.. but they're invalid.
  # access_key = var.aws_access_key_id
  # secret_key = var.aws_secret_access_key

  version = "~> 2.0"
  region  = var.region
}

module "main_vpc" {
  source     = "./modules/vpc"
  env        = var.env
  team       = var.team
  region     = var.region
  cidr_block = var.cidr_block
}
