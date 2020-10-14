output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_a_id" {
  description = "The ID of public subnet a"
  value       = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  description = "The ID of public subnet a"
  value       = aws_subnet.public_subnet_b.id
}

output "private_subnet_a_id" {
  description = "The ID of private subnet a"
  value       = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  description = "The ID of private subnet b"
  value       = aws_subnet.private_subnet_b.id
}

output "public_subnet_a_cidr" {
  description = "The CIDR block for public subnet a"
  value       = var.public_subnet_a_cidr
}

output "public_subnet_b_cidr" {
  description = "The CIDR block for public subnet b"
  value       = var.public_subnet_b_cidr
}
