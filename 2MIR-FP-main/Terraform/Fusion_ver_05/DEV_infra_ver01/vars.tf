#################### /vars.tf

variable "uptime" {
  default = "0001"
}

variable "infra_tfstate" {
  type    = string
  default = "TEST-1412/terraform.tfstate"
}