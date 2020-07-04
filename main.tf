# Set up backend to store .tfstate file
# https://www.terraform.io/docs/backends/types/index.html
# https://www.terraform.io/docs/backends/types/s3.html

terraform {
  backend "s3" {
    bucket = "joes-tf-state"
    key    = "state_files/terraform.tfstate"
    region = "ap-southeast-2"
  }
}


# Setup our aws provider
provider "aws" {
  # Don't commit keys, I have for testing.. but they're invalid.
  # access_key = var.aws_access_key_id
  # secret_key = var.aws_secret_access_key

  version = "~> 2.0"
  region = "ap-southeast-2"
}

# Doco https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html

# Virtual Private Cloud 
# https://www.terraform.io/docs/providers/aws/r/vpc.html
# https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
resource "aws_vpc" "main" { # "aws_vps" = type , "joes-vpc" = name
  cidr_block = "10.0.0.0/16" # 65536 ip addresses
  tags = {
    name = "Main VPC"
    team = var.team
    env = var.env
  }
}

# Internet Gateway 
# Resources in public subnets to communicate to the internet
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main IG"
    env = var.env
  }
}
