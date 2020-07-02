# Setup our aws provider
provider "aws" {
  # access_key = "${var.aws_access_key_id}"
  # secret_key = "${var.aws_secret_access_key}"
  # region = "${var.vpc_region}"
  version = "~> 2.0"
  region = "ap-southeast-2"
}

# Define a vpc
resource "aws_vpc" "joes-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "JoesTestVPC"
  }
}
