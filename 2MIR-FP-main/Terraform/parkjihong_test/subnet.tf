##public_subnet 생성
#public_subnet_2a
resource "aws_subnet" "pub2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub2a_subnet1_name
  }
}
#public_subnet_2c
resource "aws_subnet" "pub2c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.20.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = var.pub2c_subnet1_name
  }
}

##private_subnet 생성
#private_subnet_2a masternode
resource "aws_subnet" "pri2a11" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = var.pri2a_subnet2_name
  }
}
#private_subnet_2a workernode1
resource "aws_subnet" "pri2a12" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.12.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = var.pri2a_subnet3_name
  }
}
#private_subnet_2c
resource "aws_subnet" "pri2c21" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.21.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = var.pri2c_subnet2_name
  }
}
#private_subnet_2c workernode2
resource "aws_subnet" "pri2c22" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.22.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = var.pri2c_subnet3_name
  }
}