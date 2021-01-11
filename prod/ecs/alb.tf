# Application Load Balancer - distributes requests accross targets
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html
# https://docs.bridgecrew.io/docs/networking_1-port-security
resource "aws_lb" "ecs-load-balancer" {
  name               = "ecs-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_public_sg.id]
  subnets            = [data.terraform_remote_state.vpc.outputs.public_subnet_a_id, data.terraform_remote_state.vpc.outputs.public_subnet_b_id]

  tags = {
    Name = "ecs-alb"
  }
  #checkov:skip=CKV_AWS_91:Prod you _should_ enable logging for the lb (but I'm not)
}

# Target Groups - Used for routing requests to one or more registered targets
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "ecs-target-group" {
  name     = "ecs-target-group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.vpc.outputs.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }

  tags = {
    Name = "ecs-target-group"
  }
}

# A listener is a process that checks for connection requests, using the protocol and port that you configure. 
# The rules that you define for a listener determine how the load balancer routes requests to its registered targets.
# https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-listeners.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "alb-listener" {
  
  load_balancer_arn = aws_lb.ecs-load-balancer.arn
  port              = "80"
  #checkov:skip=CKV_AWS_2:Always enable HTTPS, I'm skipping for now
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}

# A Security group thats attached to the ALB
# Defines what ingress and egress is allowed for the ALB
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "alb_public_sg" {
  name        = "ecs_alb_public_sg"
  description = "ALB public access security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  # https://docs.bridgecrew.io/docs/networking_1-port-security
  # May need to add specific ip ranges.
  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.public_subnet_a_cidr, data.terraform_remote_state.vpc.outputs.public_subnet_b_cidr]
  }

  egress {
    # allow all traffic to private subnets on all protocols
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-public-sg"
  }
}
