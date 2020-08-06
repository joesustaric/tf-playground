variable "ecs_cluster" {
  description = "ECS cluster name"
}

variable "region" {
  description = "AWS region"
}

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
}
