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

resource "aws_security_group" "public_sg" {
  name        = "ecs_alb_public_sg"
  description = "Test public access security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "tcp"
    cidr_blocks = [
      "${data.terraform_remote_state.vpc.outputs.public_subnet_a_cidr}",
    "${data.terraform_remote_state.vpc.outputs.public_subnet_b_cidr}"]
  }

  egress {
    # allow all traffic to private SN
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    cidr_blocks = [
    "0.0.0.0/0"]
  }

  tags = {
    Name = "test_public_sg"
  }
}
