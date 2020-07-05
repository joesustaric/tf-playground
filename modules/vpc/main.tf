# Doco https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0
# https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html

# Virtual Private Cloud 
# https://www.terraform.io/docs/providers/aws/r/vpc.html
# https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html
resource "aws_vpc" "main" {  # "aws_vps" = type , "joes-vpc" = name
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
