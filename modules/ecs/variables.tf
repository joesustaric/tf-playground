
variable "ecs_cluster" {
    type        = string
    description = "ECS cluster name"
}

variable "ecs_key_pair_name" {
    type        = string
  description = "EC2 instance key pair name"
}

variable "region" {
    type        = string
  description = "AWS region"
}

# variable "availability_zone" {
#   description = "availability zone used for the demo, based on region"
#   default = {
#     us-east-1 = "us-east-1"
#   }
# }

########################### Autoscale Config ################################

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}
