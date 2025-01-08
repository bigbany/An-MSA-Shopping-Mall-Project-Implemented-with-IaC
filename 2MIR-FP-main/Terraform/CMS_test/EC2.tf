############################## BASTION EC2 생성(for BASTION)
resource "aws_instance" "MIR_BASTION" {
  ami                    = data.aws_ami.ubuntu22.id
  instance_type          = var.instance_type # t3.large
  vpc_security_group_ids = [aws_security_group.MIR_BASTION_SG.id]
  subnet_id              = aws_subnet.pub_A_10.id # 서브넷 ID로 변경
  private_ip             = "172.16.10.10"

  # 키페어 지정
  key_name = aws_key_pair.mykey.key_name

  # 스토리지
root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
  }

  /*# 유저데이터 지정
  user_data = templatefile("userdata1.tpl", {
    rds_endpoint = aws_db_instance.tf-db.address
    db_user      = var.db_user
    db_password  = var.db_password
  })


  # 유저데이저 변경시 종료 후 시작
  user_data_replace_on_change = true
  
  # 버전 갱신시 인스턴스 롤링 업데이트.
  lifecycle {
    create_before_destroy = true
    replace_triggered_by = [
      aws_launch_template.web.latest_version
    ]
  }*/
  
  tags = {
    Name = "${var.myName}-forBastion"
  }
}
############################## BASTION EC2 EIP, EBS 생성 & 연결
resource "aws_eip" "MIR_BASTION_EIP" {
  #vpc       = true
  domain = "vpc"
  instance  = aws_instance.MIR_BASTION.id
}

############################## Sub A _Master Node Ins 생성(for k8s master)
resource "aws_instance" "MIR_A_Master_01" {
  ami                    = data.aws_ami.ubuntu22.id
  instance_type          = var.instance_type # t3.large
  vpc_security_group_ids = [aws_security_group.MIR_MasterNode_SG.id]
  subnet_id              = aws_subnet.pri_A_11.id # 서브넷 ID로 변경
  private_ip             = "172.16.11.10"

  # 키페어 지정
  key_name = aws_key_pair.mykey.key_name

  # 스토리지
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "${var.myName}-forMasterA-01"
  }  
}


############################## Sub A _Worker Node Ins 생성(for k8s worker)
resource "aws_instance" "MIR_A_WK_01" {
  ami                    = data.aws_ami.ubuntu22.id
  instance_type          = var.instance_type # t3.large
  vpc_security_group_ids = [aws_security_group.MIR_WorkerNode_SG.id]
  subnet_id              = aws_subnet.pri_A_11.id # 서브넷 ID로 변경
  private_ip             = "172.16.11.101"

  # 키페어 지정
  key_name = aws_key_pair.mykey.key_name

  # 스토리지
root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "${var.myName}-forWorkerA-01"
  }  
}

############################## Sub C _Worker Node Ins 생성(for k8s worker)
resource "aws_instance" "MIR_C_WK_01" {
  ami                    = data.aws_ami.ubuntu22.id
  instance_type          = var.instance_type # t3.large
  vpc_security_group_ids = [aws_security_group.MIR_WorkerNode_SG.id]
  subnet_id              = aws_subnet.pri_C_21.id # 서브넷 ID로 변경
  private_ip             = "172.16.21.101"

  # 키페어 지정
  key_name = aws_key_pair.mykey.key_name

  # 스토리지
root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
  }
  tags = {
    Name = "${var.myName}-forWorkerC-01"
  }  
}



############################## Bastion 보안그룹 생성
resource "aws_security_group" "MIR_BASTION_SG" {
  name_prefix = "MIR_BASTION_SG-"
  description = "only bastion SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
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

  lifecycle {
    create_before_destroy = true # 새 보안그룹 생성시 생성 전에 삭제
  }

  tags = {
    Name = "MIR-BastionSG"
  }
}
############################## Master Node 보안그룹 생성 (나중에 추가 제한 필요)
resource "aws_security_group" "MIR_MasterNode_SG" {
  name_prefix = "MIR_MasterNode_SG-"
  description = "for Master ec SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow port for asg"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow port for asg"
    from_port   = var.MasterNode_server_port
    to_port     = var.MasterNode_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.MIR_WorkerNode_SG.id]
  }

  ingress {
    description = "SSH from VPC"
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

  lifecycle {
    create_before_destroy = true # 새 보안그룹 생성시 생성 전에 삭제
  }

  tags = {
    Name = "MIR-NodeSG"
  }
}
############################## Worker Node 보안그룹 생성 (나중에 추가 제한 필요)
resource "aws_security_group" "MIR_WorkerNode_SG" {
  name_prefix = "MIR_WorkerNode_SG-"
  description = "for master ec SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "allow port for asg"
    from_port   = var.WorkerNode_server_port
    to_port     = var.WorkerNode_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from VPC"
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

  lifecycle {
    create_before_destroy = true # 새 보안그룹 생성시 생성 전에 삭제
  }

  tags = {
    Name = "MIR-NodeSG"
  }
}
