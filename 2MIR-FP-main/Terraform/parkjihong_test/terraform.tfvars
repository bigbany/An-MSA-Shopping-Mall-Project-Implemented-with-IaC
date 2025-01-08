#terraform.tf
eip_name_2a = "tf-eip-2a"
eip_name_2c = "tf-eip-2c"

nat_gateway_name     = "tf-nat-public"
ec2_bastion_eip_name = "tf-bastion-eip"

#ec2
server_port      = 80
ssh_port         = 22
k8s_port         = 6443
bastion_ec2      = "bastion"
bastion_image_id = ""
masternode       = "masternode"
workernode1      = "workernode1"
workernode2      = "workernode2"

#security_group
bastion_security_group_name    = "bastion_security"
masternode_security_group_name = "master_node_security"
workernode_security_group_name = "worker_node_security"

##subnet public, private
#public
pub2a_subnet1_name = "tf-public-subnet-ap-norteast-2a"
pub2c_subnet1_name = "tf-public-subnet-ap-norteast-2c"
#private subnet 2a
pri2a_subnet2_name = "tf-private-subnet1-ap-norteast-2a"
pri2a_subnet3_name = "tf-private-subnet2-ap-norteast-2a"
#private subnet 2c
pri2c_subnet2_name = "tf-private-subnet1-ap-norteast-2c"
pri2c_subnet3_name = "tf-private-subnet2-ap-norteast-2c"