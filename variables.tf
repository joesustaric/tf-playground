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
  type = string
  default = "ap-southeast-2"
}

variable "env" {
  type = string
  default = "production"
  description = "The name of the Environment"
}

variable "team" {
  type = string
  default = "team-coffee"
  description = "Team that owns the environmnet"
}