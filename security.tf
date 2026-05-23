resource "aws_security_group" "alb_security_group" {
  name        = "alb_security_group"
  description = "Allow alb inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow alb_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_alb_inbound_traffic" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_alb_traffic_outbound" {
  security_group_id = aws_security_group.alb_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" 
}

resource "aws_security_group" "ecs_security_group" {
  name        = "ecs_security_group"
  description = "Allow ecs inbound traffic and outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow ecs_security_group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ecs_inbound_traffic" {
  security_group_id = aws_security_group.ecs_security_group.id
  referenced_security_group_id = aws_security_group.alb_security_group.id
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "allow_ecs_traffic_outbound" {
  security_group_id = aws_security_group.ecs_security_group.id
  ip_protocol       = "-1" 
  cidr_ipv4         = "0.0.0.0/0"
}


