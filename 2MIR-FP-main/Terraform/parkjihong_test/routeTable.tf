##public_route_table - IGW 적용
resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "tf-rtb-public"
  }
}

resource "aws_route_table_association" "pub2a" {
  subnet_id      = aws_subnet.pub2a.id
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pub2c" {
  subnet_id      = aws_subnet.pub2c.id
  route_table_id = aws_route_table.pub.id
}

##private_route_table 2a - NAT 적용
resource "aws_route_table" "pri2a11" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_a.id
  }
  tags = {
    Name = "tf-rtb-private1"
  }
}

resource "aws_route_table" "pri2a12" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_a.id
  }
  tags = {
    Name = "tf-rtb-private1"
  }
}
#private_route_table 2c
resource "aws_route_table" "pri2c21" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_a.id
  }
  tags = {
    Name = "tf-rtb-private2"
  }
}
resource "aws_route_table" "pri2c22" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.gw_a.id
  }
  tags = {
    Name = "tf-rtb-private2"
  }
}

resource "aws_route_table_association" "pri2a11" {
  subnet_id      = aws_subnet.pri2a11.id
  route_table_id = aws_route_table.pri2a11.id
}
resource "aws_route_table_association" "pri2a12" {
  subnet_id      = aws_subnet.pri2a12.id
  route_table_id = aws_route_table.pri2a12.id
}

resource "aws_route_table_association" "pri2c21" {
  subnet_id      = aws_subnet.pri2c21.id
  route_table_id = aws_route_table.pri2c21.id
}
resource "aws_route_table_association" "pri2c22" {
  subnet_id      = aws_subnet.pri2c22.id
  route_table_id = aws_route_table.pri2c22.id
}