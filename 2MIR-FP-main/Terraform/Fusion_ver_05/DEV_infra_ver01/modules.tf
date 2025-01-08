#################### /modules.tf

### /modules/vpc
module "vpc" {
  source = "./modules/vpc"

  uptime = formatdate("YYYY-MM-DD'T 'hh:mm", timeadd(timestamp(), "9h"))

  AZz       = ["a", "c"]
  Pub_net   = [10, 20]
  Pri_net_A = ["11", "12", "13"]
  Pri_net_C = ["21", "22", "23"]
}
output "vpc_id" {           # output "plan때 볼 이름"
  value = module.vpc.vpc_id # value = module.<모듈명>.<소스 아웃풋 명>
}
output "Bastion_subnet" {
  value       = module.vpc.pub_subnet_id[0]
  description = "172.16.10.10"
}
output "Master_subnet" {
  value       = module.vpc.pri_A_subnet_id[0]
  description = "172.16.11.10"
}
output "worker_A_PRInet" {
  value = module.vpc.pri_A_subnet_id
}
output "worker_C_PRInet" {
  value = module.vpc.pri_C_subnet_id
}

### /modules/SG
module "SG" {
  source = "./modules/SG"

  uptime = formatdate("YYYY-MM-DD'T 'hh:mm", timeadd(timestamp(), "9h"))
}
output "BASTION_SG_id" {
  value = module.SG.bastionSG_id
}
output "K8s_Master_SG_id" {
  value = module.SG.k8s_Master_SG_id
}

### /modules/global
module "global" {
  source = "./modules/global"

  uptime = formatdate("YYYY-MM-DD", timeadd(timestamp(), "9h"))
}
output "ec2_s3_profile" {
  value = module.global.ec2_s3_profile
}

### /modules/mgmt
module "mgmt" {
  source = "./modules/mgmt"

  uptime        = formatdate("YYYY-MM-DD'T 'hh:mm", timeadd(timestamp(), "9h"))
  infra_tfstate = var.infra_tfstate
}
