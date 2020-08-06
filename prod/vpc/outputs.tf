output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.main_vpc.vpc_id
}

output "private_subnet_a_id" {
  description = "The ID of private subnet a"
  value       = module.main_vpc.private_subnet_a_id
}

output "private_subnet_b_id" {
  description = "The ID of private subnet b"
  value       = module.main_vpc.private_subnet_b_id
}
