#################### /modules/vpc/vpc.tf

### VPC, IGW

##### VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name    = "${var.project}-${var.TEAM}-vpc"
    uptime  = "${var.uptime_L}"
    TYPE    = "${var.project}-${var.TYPE}"
  }
}

##### IGW 생성
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project}_igw"
    TYPE    = "${var.project}-${var.TYPE}"
    TEAM    = "${var.TEAM}"
  }
}