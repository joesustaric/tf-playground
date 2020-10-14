# ecs-service-role
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/instance_IAM_role.html
# IAM roles are required for the ECS container agent and ECS service scheduler.
# This is the policy for the AWS ECS service (docker container) 
data "aws_iam_policy_document" "ecs-service-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

# Create the ECS Service Role and attach the above policy document to it
resource "aws_iam_role" "ecs-service-role" {
  name               = "ecs-service-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-service-policy.json
}

# This managed policy allows Elastic Load Balancing load balancers to register and deregister 
# Amazon ECS container instances on your behalf.
# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs_managed_policies.html#AmazonEC2ContainerServiceRole
resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

