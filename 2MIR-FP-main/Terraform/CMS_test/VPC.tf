################### VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "172.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "MIR_vpc"
  }
}

################### 인터넷 게이트웨이
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MIR_igw"
  }
}

################### NAT 게이트웨이 & EIP on pub_A_10
resource "aws_nat_gateway" "MIR-nat-01" {
  allocation_id = aws_eip.MIR-nat-eip-01.id
  subnet_id     = aws_subnet.pub_A_10.id

  tags = {
    Name = "MIR-nat-01"
  }

  # 버전 갱신시 인스턴스 롤링 업데이트.
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_internet_gateway.gw]
}
resource "aws_eip" "MIR-nat-eip-01" {
  domain = "vpc"

  tags = {
    Name = "MIR-nat-eip-01"
  }
}

################### (2nd)NAT 게이트웨이 & EIP on pub_C_10
resource "aws_nat_gateway" "MIR-nat-02" {
  allocation_id = aws_eip.MIR-nat-eip-02.id
  subnet_id     = aws_subnet.pub_C_10.id

  tags = {
    Name = "MIR-nat-02"
  }

  # 버전 갱신시 인스턴스 롤링 업데이트.
  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_internet_gateway.gw]
}
resource "aws_eip" "MIR-nat-eip-02" {
  domain = "vpc"

  tags = {
    Name = "MIR-nat-eip-02"
  }
}

################### PUB-서브넷
resource "aws_subnet" "pub_A_10" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.10.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name                     = "MIR-subnet-PUB-A"
    type                     = "public"
    "kubernetes.io/role/elb" = 1
  }
}
resource "aws_subnet" "pub_C_10" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.20.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = "true"

  tags = {
    Name                     = "MIR-subnet-PUB-C"
    type                     = "public"
    "kubernetes.io/role/elb" = 1
  }
}

################### PRI-서브넷
resource "aws_subnet" "pri_A_11" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.11.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name                              = "MIR-subnet-PRI-A11"
    type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "pri_A_12" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.12.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name                              = "MIR-subnet-PRI-A12"
    type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "pri_A_13" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.13.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = "false"

  tags = {
    Name                              = "MIR-subnet-PRI-A13"
    type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}


resource "aws_subnet" "pri_C_21" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.21.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = "false"

  tags = {
    Name                              = "MIR-subnet-PRI-C21"
    type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "pri_C_22" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.22.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = "false"

  tags = {
    Name                              = "MIR-subnet-PRI-C22"
    type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_subnet" "pri_C_23" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.23.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = "false"

  tags = {
    Name                              = "MIR-subnet-PRI-C23"
    type                              = "private"
    "kubernetes.io/role/internal-elb" = 1
  }
}

################### 라우팅 테이블
resource "aws_route_table" "pub_rtb" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id #Internet Gateway 별칭 입력
  }
  tags = { Name = "pub-rtb" } #태그 설정
}


resource "aws_route_table" "pri_rtb-a-01" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MIR-nat-01.id
  }
  tags = { Name = "pri-rtb-a" } #태그 설정
}

resource "aws_route_table" "pri_rtb-a-02" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MIR-nat-01.id
  }
  tags = { Name = "pri-rtb-a" } #태그 설정
}

resource "aws_route_table" "pri_rtb-a-03" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MIR-nat-01.id
  }
  tags = { Name = "pri-rtb-a" } #태그 설정
}


resource "aws_route_table" "pri_rtb-c-01" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MIR-nat-02.id
  }
  tags = { Name = "pri-rtb-c" } #태그 설정
}

resource "aws_route_table" "pri_rtb-c-02" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MIR-nat-02.id
  }
  tags = { Name = "pri-rtb-c" } #태그 설정
}

resource "aws_route_table" "pri_rtb-c-03" {
  vpc_id = aws_vpc.main.id #VPC 별칭 입력
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.MIR-nat-02.id
  }
  tags = { Name = "pri-rtb-c" } #태그 설정
}

################### rtb - subnet 연결
resource "aws_route_table_association" "pub-sub-rtb-a" {
  subnet_id      = aws_subnet.pub_A_10.id
  route_table_id = aws_route_table.pub_rtb.id
}
resource "aws_route_table_association" "pub-sub-rtb-c" {
  subnet_id      = aws_subnet.pub_C_10.id
  route_table_id = aws_route_table.pub_rtb.id
}


resource "aws_route_table_association" "pri-sub-rtb-a-01" {
  subnet_id      = aws_subnet.pri_A_11.id
  route_table_id = aws_route_table.pri_rtb-a-01.id
}
resource "aws_route_table_association" "pri-sub-rtb-a-02" {
  subnet_id      = aws_subnet.pri_A_12.id
  route_table_id = aws_route_table.pri_rtb-a-02.id
}
resource "aws_route_table_association" "pri-sub-rtb-a-03" {
  subnet_id      = aws_subnet.pri_A_13.id
  route_table_id = aws_route_table.pri_rtb-a-03.id
}


resource "aws_route_table_association" "pri-sub-rtb-c-01" {
  subnet_id      = aws_subnet.pri_C_21.id
  route_table_id = aws_route_table.pri_rtb-c-01.id
}
resource "aws_route_table_association" "pri-sub-rtb-c-02" {
  subnet_id      = aws_subnet.pri_C_22.id
  route_table_id = aws_route_table.pri_rtb-c-02.id
}
resource "aws_route_table_association" "pri-sub-rtb-c-03" {
  subnet_id      = aws_subnet.pri_C_23.id
  route_table_id = aws_route_table.pri_rtb-c-03.id
}
