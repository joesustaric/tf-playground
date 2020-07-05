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