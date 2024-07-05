resource "aws_vpc" "webapp" {

  cidr_block           = "10.8.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(local.tags, { Name : "webapp-vpc" })
}


resource "aws_subnet" "webapp_a" {
  vpc_id            = aws_vpc.webapp.id
  cidr_block        = "10.8.0.0/24"
  availability_zone = "eu-west-1a"

  tags = merge(local.tags, { Name : "webapp-eu-west-1a" })
}

resource "aws_subnet" "webapp_b" {
  vpc_id            = aws_vpc.webapp.id
  cidr_block        = "10.8.1.0/24"
  availability_zone = "eu-west-1b"

  tags = merge(local.tags, { Name : "webapp-eu-west-1b" })
}

resource "aws_internet_gateway" "webapp" {
  vpc_id = aws_vpc.webapp.id

  tags = merge(local.tags)
}

resource "aws_route_table" "webapp" {
  vpc_id = aws_vpc.webapp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp.id
  }

  tags = merge(local.tags)
}

resource "aws_route_table_association" "webapp_a" {
  subnet_id      = aws_subnet.webapp_a.id
  route_table_id = aws_route_table.webapp.id
}

resource "aws_route_table_association" "webapp_b" {
  subnet_id      = aws_subnet.webapp_b.id
  route_table_id = aws_route_table.webapp.id
}
