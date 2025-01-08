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
