#################### /modules/vpc/vars.tf


##### <공용>
variable "uptime_L" {
    default = "0001"
}

variable "uptime_S" {
    default = "0001"
}

variable "project" {
    default = "MIR"
}

variable "TYPE" {
    default = "NONE"
}

variable "region" {
    default = "ap-northeast-2"
}

variable "TEAM" {
    default = "NONE"
}

##### </공용>

##### <vpc>
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
##### </vpc>