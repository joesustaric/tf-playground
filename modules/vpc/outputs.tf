output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_a_id" {
  description = "The ID of private subnet a"
  value       = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  description = "The ID of private subnet b"
  value       = aws_subnet.private_subnet_b.id
}
