#################### /modules/SG/output.tf

output "bastionSG_id" {
  value = aws_security_group.bastionSG.id
}

output "k8s_Master_SG_id" {
  value = aws_security_group.k8s_Master_SG.id
}