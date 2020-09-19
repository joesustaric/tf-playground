# main creds for AWS connection
# Don't need this as this uses aws-vault
# But I'll leave here incase someone jsut wants to play with this
# directly without aws-vault

# variable "aws_access_key_id" {
#   description = "AWS access key"
# }

# variable "aws_secret_access_key" {
#   description = "AWS secret access key"
# }

# variable "ecs_cluster" {
#   description = "ECS cluster name"
# }

# variable "ecs_key_pair_name" {
#   description = "EC2 instance key pair name"
# }

variable "region" {
  type        = string
  description = "AWS region"
}

########################### Autoscale Config ################################

# variable "max_instance_size" {
#   description = "Maximum number of instances in the cluster"
# }

# variable "min_instance_size" {
#   description = "Minimum number of instances in the cluster"
# }

# variable "desired_capacity" {
#   description = "Desired number of instances in the cluster"
# }

# Get these from VPC outputs.
# variable "availability_zone" {
#   description = "availability zone used for the demo, based on region"
#   default = {
#     us-east-1 = "us-east-1"
#   }
# }

########################### Test VPC Config ################################

# Get these as VPC outputs
# variable "test_vpc" {
#   description = "VPC name for Test environment"
# }

# variable "test_network_cidr" {
#   description = "IP addressing for Test Network"
# }

# variable "test_public_01_cidr" {
#   description = "Public 0.0 CIDR for externally accessible subnet"
# }

# variable "test_public_02_cidr" {
#   description = "Public 0.0 CIDR for externally accessible subnet"
# }
