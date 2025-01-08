####################### 데이터 소스
# vpc
data "aws_vpc" "vpc" {
  default = false
  id      = aws_vpc.main.id
}
# subnet
data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  tags = {
    type = "Private"
  }
}

# 최신 Ubuntu22
data "aws_ami" "ubuntu22" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}
