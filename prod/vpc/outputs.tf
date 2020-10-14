output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.main_vpc.vpc_id
}

output "public_subnet_a_id" {
  description = "The ID of public subnet a"
  value       = module.main_vpc.public_subnet_a_id
}

output "public_subnet_b_id" {
  description = "The ID of public subnet b"
  value       = module.main_vpc.public_subnet_b_id
}

output "private_subnet_a_id" {
  description = "The ID of private subnet a"
  value       = module.main_vpc.private_subnet_a_id
}

output "private_subnet_b_id" {
  description = "The ID of private subnet b"
  value       = module.main_vpc.private_subnet_b_id
}

output "public_subnet_a_cidr" {
  description = "The CIDR block for public subnet a"
  value       = var.public_subnet_a_cidr
}

output "public_subnet_b_cidr" {
  description = "The CIDR block for public subnet b"
  value       = var.public_subnet_b_cidr
}
