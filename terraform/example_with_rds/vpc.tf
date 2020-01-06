# Internet VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags = {
    Name = var.vpc_key,
    VPC_KEY = var.vpc_key
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Subnets
resource "aws_subnet" "main_vpc-public-1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "main_vpc-public-1",
    VPC_KEY = var.vpc_key
  }
}
resource "aws_subnet" "main_vpc-public-2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "main_vpc-public-2",
    VPC_KEY = var.vpc_key
  }
}
resource "aws_subnet" "main_vpc-public-3" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "main_vpc-public-3",
    VPC_KEY = var.vpc_key
  }
}
resource "aws_subnet" "main_vpc-private-1" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "main_vpc-private-1",
    VPC_KEY = var.vpc_key
  }
}
resource "aws_subnet" "main_vpc-private-2" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "main_vpc-private-2",
    VPC_KEY = var.vpc_key
  }
}
resource "aws_subnet" "main_vpc-private-3" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "main_vpc-private-3",
    VPC_KEY = var.vpc_key
  }
}

# Internet GW
resource "aws_internet_gateway" "main_vpc-gw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "main_vpc",
    VPC_KEY = var.vpc_key
  }
}

# route tables
resource "aws_route_table" "main_vpc-public" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_vpc-gw.id
  }
  tags = {
    Name = "main_vpc-public-1",
    VPC_KEY = var.vpc_key
  }
}

# route associations public
resource "aws_route_table_association" "main_vpc-public-1-a" {
  subnet_id = aws_subnet.main_vpc-public-1.id
  route_table_id = aws_route_table.main_vpc-public.id
}
resource "aws_route_table_association" "main_vpc-public-2-a" {
  subnet_id = aws_subnet.main_vpc-public-2.id
  route_table_id = aws_route_table.main_vpc-public.id
}
resource "aws_route_table_association" "main_vpc-public-3-a" {
  subnet_id = aws_subnet.main_vpc-public-3.id
  route_table_id = aws_route_table.main_vpc-public.id
}
resource "aws_route_table_association" "main_vpc-private-1-a" {
  subnet_id = aws_subnet.main_vpc-private-1.id
  route_table_id = aws_route_table.main_vpc-public.id
}
resource "aws_route_table_association" "main_vpc-private-2-a" {
  subnet_id = aws_subnet.main_vpc-private-2.id
  route_table_id = aws_route_table.main_vpc-public.id
}
resource "aws_route_table_association" "main_vpc-private-3-a" {
  subnet_id = aws_subnet.main_vpc-private-3.id
  route_table_id = aws_route_table.main_vpc-public.id
}

resource "aws_main_route_table_association" "a" {
  vpc_id = aws_vpc.main_vpc.id
  route_table_id = aws_route_table.main_vpc-public.id
}

locals {
  public_subnets = list(aws_subnet.main_vpc-public-1.id, aws_subnet.main_vpc-public-2.id, aws_subnet.main_vpc-public-3.id)
}