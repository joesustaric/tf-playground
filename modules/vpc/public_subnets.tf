# Public Subnet a

# Public subnet is a subset of IP's which can access the internet via
# the internet gateway
resource "aws_subnet" "public_subnet_a" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.public_subnet_a_cidr
  availability_zone_id = var.az_zone_a_id

  tags = {
    Name = "public-subnet-a-${var.team}"
    Env  = var.env
  }
}

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.igw.id # route traffic through the Internet Gateway (public)
}

# Public Subnet b

# Public subnet is a subset of IP's which can access the internet via
# the internet gateway
resource "aws_subnet" "public_subnet_b" {
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.public_subnet_b_cidr
  availability_zone_id = var.az_zone_b_id

  tags = {
    Name = "public-subnet-b-${var.team}"
    Env  = var.env
  }
}

resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.igw.id # route traffic through the Internet Gateway (public)
}
