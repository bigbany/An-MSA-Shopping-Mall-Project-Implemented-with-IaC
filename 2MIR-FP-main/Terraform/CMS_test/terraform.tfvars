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
