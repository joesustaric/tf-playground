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

variable "az_zone_a_id" {
  type = string
  description = "The aws zone id st avalability zone a for the region"
}

variable "public_subnet_a_cidr" {
  type = string
  description = "The CIDR block for public subnet a"
}

variable "az_zone_b_id" {
  type = string
  description = "The aws zone id st avalability zone b for the region"
}

variable "public_subnet_b_cidr" {
  type = string
  description = "The CIDR block for public subnet b"
}
