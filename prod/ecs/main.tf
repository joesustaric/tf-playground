# http://blog.shippable.com/setup-a-container-cluster-on-aws-with-terraform-part-2-provision-a-cluster

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

# To retreive the VPC outputs
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt = true
    bucket  = "joes-tf-state-encrypted"
    key     = "prod/vpc/terraform.tfstate"
    region  = "ap-southeast-2"
  }
}

## ECS 2 node cluster
## Use aws ECS AMI
## security groups

resource "aws_ecs_cluster" "test-ecs-cluster" {
  name = var.ecs_cluster
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                = "ecs-autoscaling-group"
  max_size            = var.max_instance_size
  min_size            = var.min_instance_size
  desired_capacity    = var.desired_capacity
  vpc_zone_identifier = [data.terraform_remote_state.vpc.outputs.private_subnet_a_id, data.terraform_remote_state.vpc.outputs.private_subnet_b_id]
}
