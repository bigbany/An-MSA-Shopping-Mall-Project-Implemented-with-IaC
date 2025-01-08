#variable.tf
#eip
variable "eip_name_2a" {
  type = string
}

#eip
variable "ec2_bastion_eip_name" {
  type = string
}

#ec2 port
variable "server_port" {
  type = string
}
#ssh_port
variable "ssh_port" {
  type = string
}

#k8s_port
variable "k8s_port" {
  type = string
}

##bastion
variable "bastion_ec2" {
  type = string
}

##bastion
variable "masternode" {
  type = string
}

##workernode1
variable "workernode1" {
  type = string
}

##workernode2
variable "workernode2" {
  type = string
}

#image_id
variable "bastion_image_id" {
  type = string
}

#security
variable "bastion_security_group_name" {
  type = string
}
variable "masternode_security_group_name" {
  type = string
}
variable "workernode_security_group_name" {
  type = string
}

#nat_gatway
variable "nat_gateway_name" {
  type = string
}

#subet public
variable "pub2a_subnet1_name" {
  type = string
}
variable "pub2c_subnet1_name" {
  type = string
}
#subnet private 2a
variable "pri2a_subnet2_name" {
  type = string
}
variable "pri2a_subnet3_name" {
  type = string
}
#subnet private 2c
variable "pri2c_subnet2_name" {
  type = string
}
variable "pri2c_subnet3_name" {
  type = string
}