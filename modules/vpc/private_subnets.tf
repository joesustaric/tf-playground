#### private a
resource "aws_subnet" "private_subnet_a" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_a_cidr
  availability_zone_id = data.aws_availability_zones.available.zone_ids[0]

  tags = {
    Name = "private-subnet-a-${var.team}"
  }
}

# Associate the private subnet to the NGW so resources can talk to the internet
# but access in the the private subnet is blocked.
resource "aws_route_table_association" "private_subnet_a" {
  subnet_id = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.ngw_rt.id
}

#### private b
resource "aws_subnet" "private_subnet_b" {
  vpc_id = aws_vpc.main.id
  cidr_block = var.private_subnet_b_cidr
  availability_zone_id = data.aws_availability_zones.available.zone_ids[1]

  tags = {
    Name = "private-subnet-b-${var.team}"
  }
}

# Associate the private subnet to the NGW so resources can talk to the internet
# but access in the the private subnet is blocked.
resource "aws_route_table_association" "private-ap-southeast-1b" {
  subnet_id = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.ngw_rt.id
}