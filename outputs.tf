output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = [for s in aws_subnet.private_subnets : s.id]
}

output "alb_security_group_id" {
  description = "The ID of the ALB Security Group"
  value       = aws_security_group.alb_security_group.id
}

output "ecs_security_group_id" {
  description = "The ID of the ECS Security Group"
  value       = aws_security_group.ecs_security_group.id
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_alb.demo_alb.dns_name
}