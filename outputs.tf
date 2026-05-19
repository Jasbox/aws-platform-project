output "vpc_id" {
    description = "The ID of the VPC"
    value = aws_vpc.vpc.id
}

output "public_subnet_ids" {
    description = "List of IDs of public subnets"
    value = [for s in aws_subnet.public_subnets : s.id]
}

output "private_subnet_ids" {
    description = "List of IDs of private subnets"
    value = [for s in aws_subnet.private_subnets : s.id]
}