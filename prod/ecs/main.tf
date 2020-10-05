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

#---- ecs-service-role ---------
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# IAM roles are required for the ECS container agent and ECS service scheduler.
# Is this the service role for the aws ecs agent? (I think so)
resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}
#---------------------------------------------------------
#--------- ecs-instance-role------------------------------
# This is the role for the ECS ec2 instance.
resource "aws_iam_role" "ecs-instance-role" {
  name               = "ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# not sure why the sleep?
resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.id
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
#---------------------------------------------------------

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "joes-tf-state-encrypted"
    key            = "prod/vpc/terraform.tfstate"
    region         = "ap-southeast-2"
    # dynamodb_table = "tf-app-state"
  }
}

resource "aws_security_group" "ecs_alb_public_sg" {
    name = "ecs_alb_public_sg"
    description = "Test public access security group"
    vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

  #  ingress {
  #     from_port = 0
  #     to_port = 0
  #     protocol = "tcp"
  #     cidr_blocks = [
  #        "${var.test_public_01_cidr}",
  #        "${var.test_public_02_cidr}"]
  #   }

    egress {
        # allow all traffic to private SN
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"]
    }

    tags = { 
       Name = "test_public_sg"
     }
}

# resource "aws_alb" "ecs-load-balancer" {
#   name            = "ecs-load-balancer"
#   security_groups = ["${aws_security_group.test_public_sg.id}"]
#   subnets         = ["${aws_subnet.test_public_sn_01.id}", "${aws_subnet.test_public_sn_02.id}"]

#   tags {
#     Name = "ecs-load-balancer"
#   }
# }
