provider aws {
    access_key = ""
    secret_key = ""
    region = "us-west-2"
}

resource "aws_vpc" "first-vpc" {
  cidr_block = "10.0.0.0/16"
   tags = {
    Name = "first-vpc"
  }
}

resource "aws_internet_gateway" "first-gateway" {
  vpc_id = aws_vpc.first-vpc.id
}

resource "aws_subnet" "first-sub" {
  count = 3
  vpc_id = aws_vpc.first-vpc.id
  cidr_block = "10.0.${count.index}.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true
  tags={
    Name = "sub${count.index}"
  }
}

resource "aws_route_table" "first-route" {
  count = 3
  vpc_id = aws_vpc.first-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.first-gateway.id
  }
  tags={
    Name = "route${count.index}"
  }
}

resource "aws_route_table_association" "example" {
  count = 3
  subnet_id = aws_subnet.first-sub.*.id[count.index]
  route_table_id = aws_route_table.first-route.*.id[count.index]
}