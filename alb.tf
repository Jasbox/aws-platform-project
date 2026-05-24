resource "aws_alb" "demo_alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [for s in aws_subnet.public_subnets : s.id]

  tags = {
    Name      = "demo_alb"
    Terraform = "true"
  }

}

resource "aws_alb_target_group" "demo_target_group" {
  name        = "demo-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
  health_check {
    path                = "/"
    interval            = "30"
    timeout             = "5"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name      = "demo_target_group"
    Terraform = "true"
  }
}

resource "aws_alb_listener" "demo_listener" {
  load_balancer_arn = aws_alb.demo_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.demo_target_group.arn
  }
}