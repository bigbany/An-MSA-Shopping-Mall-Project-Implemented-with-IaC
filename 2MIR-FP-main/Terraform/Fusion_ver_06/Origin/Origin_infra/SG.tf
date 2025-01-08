#################### /modules/SG/SG.tf
### SG (베스천, k8s 마스터, k8s 워커)

# Bastion 보안그룹
resource "aws_security_group" "bastionSG" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "${var.project}-Bastion-SG"
    uptime  = "${var.uptime_S}"
    TYPE    = "${var.project}-${var.TYPE}"
    TEAM    = "${var.TEAM}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# K8s Master 보안그룹
resource "aws_security_group" "k8s_Master_SG" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port   = 6443
    protocol  = "tcp"
    self      = true # 자신을 소스로 지정
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-k8s_Master-SG"
    TYPE    = "${var.project}-${var.TYPE}"
    TEAM    = "${var.TEAM}"
  }

  lifecycle {
    create_before_destroy = true
  }
}