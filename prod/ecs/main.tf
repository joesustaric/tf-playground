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

# Use aws ECS AMI - Dont forget to subscribe to the Image on the AWS AMI marketplace.
# Amazon ECS-Optimized Amazon Linux 2 AMI-335758bf-b7a2-49bc-b5e0-d4a38d88607a-ami-066d06ed373b846b2.4
data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["Amazon ECS-Optimized Amazon Linux 2 AMI-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_launch_configuration" "ecs-launch-configuration" {
  name          = "ecs-launch-configuration"
  image_id      = data.aws_ami.ecs_ami.image_id
  instance_type = "t2.micro"
}

## ECS 2 node cluster
## security groups

resource "aws_ecs_cluster" "test-ecs-cluster" {
  name = var.ecs_cluster
}

resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "ecs-autoscaling-group"
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = [data.terraform_remote_state.vpc.outputs.private_subnet_a_id, data.terraform_remote_state.vpc.outputs.private_subnet_b_id]
  launch_configuration = aws_launch_configuration.ecs-launch-configuration.name
}
