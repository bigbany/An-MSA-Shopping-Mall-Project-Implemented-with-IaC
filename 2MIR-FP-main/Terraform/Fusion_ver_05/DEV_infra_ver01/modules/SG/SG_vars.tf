#################### /modules/SG/SG_vars.tf
variable "uptime" {
    default = "0001"
}

variable "vpc_id" {
    default = "nothing vpc_id"
}

variable "tempPORT" {
    default = "0"
}

variable "k8s_port" {
    default = "6443"
}

variable "infra_tfstate" {
    default = "nothing infra_tfstate"
}