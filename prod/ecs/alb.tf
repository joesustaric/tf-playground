# Application Load Balancer - distributes requests accross targets
resource "aws_lb" "ecs-load-balancer" {
  name               = "ecs-load-balancer"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = [data.terraform_remote_state.vpc.outputs.public_subnet_a_id, data.terraform_remote_state.vpc.outputs.public_subnet_b_id]

  tags = {
    Name = "ecs-alb"
  }
}

resource "aws_alb_target_group" "ecs-target-group" {
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

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.ecs-load-balancer.arn
  port              = "80"
  protocol          = "HTTPS"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}
