# Doco https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html

# Virtual Private Cloud 
# https://www.terraform.io/docs/providers/aws/r/vpc.html
# https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
resource "aws_vpc" "main" { # "aws_vps" = type , "joes-vpc" = name
  cidr_block = var.cidr_block
  tags = {
    Name        = "Main VPC"
    Team        = var.team
    Environment = var.env
  }
}

# Internet Gateway 
# Resources in public subnets to communicate to the internet
# https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "Main IG"
    Environment = var.env
  }
}

# Routing table holds routing rules
resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "igw-${var.team}"
    Environment = var.env
  }
}

# Route rule which we attach to the route table and Internet Gateway
# Here we want traffic from the gateway to go to 0.0.0.0/0
resource "aws_route" "igw-all-route" {
  route_table_id         = aws_route_table.igw.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}


resource "aws_route_table" "ngw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "ngw-${var.team}"
    Env  = var.env
  }
}

resource "aws_route" "ngw" {
  route_table_id         = aws_route_table.ngw.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main.id
}

# Elastic IP Address (Public IPv4 IP)
resource "aws_eip" "nat" {
  vpc = true
}

# NAT Gateway
# https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html
# Enable instances in a private subnet to connect to the internet or other AWS services, 
# but prevent the internet from initiating a connection with those instances
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id # Assign the Elastic IP to the NAT gateway 
  subnet_id     = aws_subnet.public_subnet_a.id

  tags = {
    Name = "nat-gateway-${var.team}"
    Env  = var.env
  }
}
