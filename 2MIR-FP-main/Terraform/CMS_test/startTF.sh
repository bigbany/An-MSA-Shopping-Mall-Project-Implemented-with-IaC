#!/bin/bash

### <KTS 시간 동기화>
echo "time check"
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
date
### </KTS 시간 동기화>

### <키페어 체크>
echo "Check mykey"
if [ -f "mykey" ] && [ -f "mykey.pub" ]; then
  ls | grep my
  echo "already key pairs. next process"
else
  echo "create mykey"
  ssh-keygen -m PEM -f mykey -N ""
  ls | grep my
fi
### </키페어 체크>


### <tf 파일 생성>
# <Main >
echo "create main.tf"
cat << 'EOF' > main.tf
terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "tf-user"
  region  = "ap-northeast-2" # Asia Pacific (Seoul)
}

############################## 키페어 생성
resource "aws_key_pair" "mykey" {
  key_name = "${var.myName}-mykey"
  #key_name_prefix   = "mykey-"
  public_key = file("mykey.pub")
}
EOF
echo $?
# </Main>


# <VPC>
echo "create VPC.tf"
cat << 'EOF' > VPC.tf
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

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.

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

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.

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
EOF
echo $?
# </VPC>


# <variables 선언>
echo "create variables"
cat << 'EOF' > variables.tf
####################### 변수 생성
# 이미지 변수
variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}

# 서버 포트 변수
variable "server_port" {
  description = "The prot the server will use for HTTP requests"
  type        = number
}

# 서버 포트 변수(WorkerNode 전용)
variable "WorkerNode_server_port" {
  description = "for node"
  type        = number
}

# 서버 포트 변수(MasterNode 전용)
variable "MasterNode_server_port" {
  description = "for node"
  type        = number
}

# 인스턴스 타입
variable "instance_type" {
  description = "instance_type"
  type        = string
}

# 인스턴스 보안그룹 이름
variable "instance_security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = "allow_http_ssh_instance"
}

# 인스턴스 이름
variable "myName" {
  description = "Your name"
  type        = string
  default     = "MIR"
}

#########################  DB
# DB 보안그룹 이름
variable "db-dg-name" {
  description = "db SG"
  type        = string
  default     = "tf-db-"
}

# DB username
variable "db_user" {
  description = "db user"
  type        = string
  default     = "admin"
}

# DB apssword
variable "db_password" {
  description = "db password"
  type        = string
  default     = "qwerqwer1"
}

# DB endpoint
/*variable "db_endpoint" {
  description = "db endpoint"
  type        = string
  default     = ${aws_db_instance.tf-db.endpoint}
}*/
EOF
echo $?
# </variables 선언>

# <Prod EC2 생성>
echo "create EC2.tf"
cat << 'EOF' > EC2.tf
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
EOF
echo $?
# </EC2 생성>

# <데이터 모음>
echo "create data.tf"
cat << 'EOF' > data.tf
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
EOF
echo $?
# </데이터 모음>


# <자체 환경 변수 입력>
echo "create terraform.tfvars"
cat << 'EOF' > terraform.tfvars
image_id                     = "ami-0c9c942bd7bf113a2" # Ubuntu22.04
instance_type                = "t3.large"
instance_security_group_name = "WEB_SG-"
server_port                  = 0
WorkerNode_server_port       = 0
MasterNode_server_port       = 0

#alb_server_port         = 80
#alb_security_group_name = "ALB_SG-"
#alb_name                = "EX-ALB"
#target_group_name       = "TG-WEB"

### 이미지 목록
# <yum>
# AML2023:"ami-04a7c24c015ef1e4c" # AML2023
# AML2:"ami-084e92d3e117f7692" # AML2

# <apt>
# Ubuntu22.04:"ami-0c9c942bd7bf113a2" # Ubuntu22.04
# Ubuntu20.04:"ami-04341a215040f91bb" # Ubuntu20.04

# <power_sh>
# Win2019:"ami-0b9903befd73c9de2" # Win2019
# Win2022core:"ami-0284d96978b36fecb" # Win2022core

# 터미널에서 입력 후 적용
# sudo timedatectl set-timezone Asia/Seoul
# export TF_VAR_myName="cms-$(date +'%H%M')"
EOF
echo $?
# </자체 환경 변수 입력>

# <유저데이터 생성>
echo "create userdata1.tpl"
cat << 'EOF' > userdata1.tpl
#!/bin/bash -ex
sudo apt update -y && sudo apt install git -y
git clone https://github.com/2MIRACLE-BTC/2MIR-FP.git
cd 2MIR-FP/k8s_setup
sh k8sSetup.sh
EOF
echo $?
# </유저데이터 생성>



# <작업명>
#echo "create "
#cat << 'EOF' > <name>

#EOF
#echo $?
# </작업명>

### tf파일 생성 후 
ls
terraform init
export TF_VAR_myName="MIR-$(date +'%H%M')";\
#terraform plan
terraform apply -auto-approve;
#echo 'terraform apply complete'

#export TF_VAR_uptime="MIR-$(date +'%H%M')"