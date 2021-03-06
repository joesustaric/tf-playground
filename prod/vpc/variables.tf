# main creds for AWS connection 
# This is here as an example of how to fail checkov
# variable "aws_access_key_id" {
#   description = "AWS access key"
#   default = "foo"
# }
# variable "aws_secret_access_key" {
#   description = "AWS secret access key"
#   default = "bar"
# }

variable "region" {
  type        = string
  description = "AWS Region to launch into"
}

variable "env" {
  type        = string
  description = "The name of the Environment"
}

variable "team" {
  type        = string
  description = "Team that owns the environmnet"
}

variable "cidr_block" {
  type        = string
  description = "CIDR address block for the VPC"
}

variable "public_subnet_a_cidr" {
  type        = string
  description = "The CIDR block for public subnet a"
}

variable "public_subnet_b_cidr" {
  type        = string
  description = "The CIDR block for public subnet b"
}

variable "private_subnet_a_cidr" {
  type        = string
  description = "The CIDR block for private subnet a"
}

variable "private_subnet_b_cidr" {
  type        = string
  description = "The CIDR block for private subnet b"
}
