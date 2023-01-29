data "aws_availability_zones" "available" {
  state = var.state
}


# VPC Resources
resource "aws_vpc" "event_driven_app" {
  cidr_block           = var.main_vpc_cidr
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames
  tags = {
    Name = "${var.service}-vpc"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.event_driven_app.id
  cidr_block        = var.public_subnet_a
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.service}-public-subnet-a"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.event_driven_app.id
  cidr_block        = var.private_subnet_a
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.service}-private-subnet-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id            = aws_vpc.event_driven_app.id
  cidr_block        = var.public_subnet_b
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.service}-public-subnet-b"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.event_driven_app.id
  cidr_block        = var.private_subnet_b
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "${var.service}-private-subnet-b"
  }
}

resource "aws_internet_gateway" "event_driven_app" {
  vpc_id = aws_vpc.event_driven_app.id
  tags = {
    Name = "${var.service}-internet-gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.event_driven_app.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.event_driven_app.id
  }
  tags = {
    Name = "${var.service}-public-route-table"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.event_driven_app.id
  tags = {
    Name = "${var.service}-private-route-table"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private.id
}

resource "aws_db_subnet_group" "public_subnet_group" {
  name = "event-driven-public"
  subnet_ids = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]
}

resource "aws_db_subnet_group" "private_subnet_group" {
  name = "event-driven-private"
  subnet_ids = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id
  ]
}
