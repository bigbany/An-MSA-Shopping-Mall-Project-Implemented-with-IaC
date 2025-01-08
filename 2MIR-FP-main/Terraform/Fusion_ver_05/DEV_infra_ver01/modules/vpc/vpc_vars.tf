#################### /modules/vpc/vars.tf

variable "uptime" {
    default = "0001"
}

variable "Pub_net" {
    type        = list(number)
}

variable "AZz" {
    type        = list(string)
    default     = ["default"]
}

variable "Pri_net_A" {
    type        = list(string)
    default     = ["default"]
}

variable "Pri_net_C" {
    type        = list(string)
    default     = ["default"]
}

variable "none" {
default = "default"
}

variable "infra_tfstate" {
    default = "nothing infra_tfstate"
}