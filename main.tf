# Setup our aws provider
provider "aws" {
  # Don't commit keys, I have for testing.. but they're invalid.
  # access_key = "${var.aws_access_key_id}"
  # secret_key = "${var.aws_secret_access_key}"

  version = "~> 2.0"
  region = "ap-southeast-2"
}

# Define a vpc
resource "aws_vpc" "joes-vpc" { # "aws_vps" = type , "joes-vpc" = name
  cidr_block = "10.0.0.0/16" # 65536 ip addresses
  tags = {
    Name = "JoesTestVPC"
    Team = "teamFoo"
  }
}
