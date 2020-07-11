# Set up backend to store .tfstate file
# https://www.terraform.io/docs/backends/types/index.html
# https://www.terraform.io/docs/backends/types/s3.html

terraform {
  required_version = "~> 0.12"
  backend "s3" {
    encrypt = true
    bucket  = "joes-tf-state-encrypted"
    key     = "prod/vpc/terraform.tfstate"
    region  = "ap-southeast-2"
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
  source                = "../../modules/vpc"
  env                   = var.env
  team                  = var.team
  region                = var.region
  cidr_block            = var.cidr_block
  az_zone_a_id          = var.az_zone_a_id
  az_zone_b_id          = var.az_zone_b_id
  public_subnet_a_cidr  = var.public_subnet_a_cidr
  public_subnet_b_cidr  = var.public_subnet_b_cidr
  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr
}
