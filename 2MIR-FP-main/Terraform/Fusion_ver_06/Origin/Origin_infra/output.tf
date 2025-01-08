#################### /modules/vpc/output.tf

output "vpc_id" {
  value = aws_vpc.main.id
}

output "pub_subnet_id" {
  value = aws_subnet.pub[*].id
}

output "pri_A_subnet_id" {
  value = aws_subnet.pri_A[*].id
}

output "pri_C_subnet_id" {
  value = aws_subnet.pri_C[*].id
}