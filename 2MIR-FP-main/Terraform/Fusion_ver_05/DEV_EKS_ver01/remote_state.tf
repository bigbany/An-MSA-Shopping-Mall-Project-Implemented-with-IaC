#################### /remote_state.tf
#################### for DEV_EKS

### data 호출 from S3/tfstate
data "terraform_remote_state" "get_infra" {
  backend   = "s3"
  config    = {
    bucket  = "mir-s3-testate"
    key     = "MIR_DEV/terraform.tfstate"
    region  = "ap-northeast-2"
  }
}