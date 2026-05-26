resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Allow alb inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow alb_security_group"
  }
}

resource "aws_security_group_rule" "allow_alb_inbound_traffic" {
  security_group_id = aws_security_group.alb_security_group.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
}

resource "aws_security_group_rule" "allow_alb_traffic_outbound" {
  security_group_id = aws_security_group.alb_security_group.id
  type              = "egress"
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
  source_security_group_id = aws_security_group.ecs_security_group.id
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Allow ecs inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow ecs_security_group"
  }
}

resource "aws_security_group_rule" "allow_ecs_inbound_traffic" {
  security_group_id            = aws_security_group.ecs_security_group.id
  source_security_group_id = aws_security_group.alb_security_group.id
  type                      = "ingress"
  from_port                    = 80
  protocol                  = "tcp"
  to_port                      = 80
}

