#################### /modules/global/output.tf
output "logS3_name" {
  value = aws_s3_bucket.MIR_S3.id
}

output "ec2_s3_profile" {
  value = aws_iam_instance_profile.ec2_s3_profile.id
}