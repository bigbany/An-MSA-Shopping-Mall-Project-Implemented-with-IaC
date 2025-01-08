
##EIP_2a
resource "aws_eip" "pub2a" {
  domain = "vpc"
  tags = {
    Name = var.eip_name_2a
  }
}

##nat_gatway
resource "aws_nat_gateway" "gw_a" {
  allocation_id = aws_eip.pub2a.id
  subnet_id     = aws_subnet.pub2a.id
  tags = {
    Name = var.nat_gateway_name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
  lifecycle {
    create_before_destroy = true
  }
}

##ec2 eip
resource "aws_eip" "bastion_eip" {
  #vpc       = true
  domain   = "vpc"
  instance = aws_instance.bastion.id
}