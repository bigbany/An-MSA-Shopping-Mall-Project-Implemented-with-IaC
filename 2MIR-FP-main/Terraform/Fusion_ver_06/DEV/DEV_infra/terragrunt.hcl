############################# ~DEV/DEV_infra/terragrunt.hcl
############################# for DEV CHILD
# 불러올 모듈 경로(=대상)
terraform {
    source = "../../Origin/Origin_infra"
}

# ROOT TERRAGRUNT.hcl 참조
include "root" {
    path = find_in_parent_folders()
}

# 지역변수 = 환경변수.hcl 참조
locals {
    env_hcl     = read_terragrunt_config(find_in_parent_folders("env.hcl"))
    # 공용
    project     = local.env_hcl.locals.project
    region      = local.env_hcl.locals.region
    uptime_L    = local.env_hcl.locals.uptime_L
    uptime_S    = local.env_hcl.locals.uptime_S
    #TYPE        = "${path_relative_to_include()}"
    TEAM        = element(split("/", path_relative_to_include()), length(split("/", path_relative_to_include())) - 2)
    TYPE        = element(split("/", path_relative_to_include()), length(split("/", path_relative_to_include())) - 1)
    

    # VPC
    AZz         = local.env_hcl.locals.AZz
    Pub_net     = local.env_hcl.locals.Pub_net
    Pri_net_A   = local.env_hcl.locals.Pri_net_A
    Pri_net_C   = local.env_hcl.locals.Pri_net_C
}


# 대상에 입력할 값
inputs = {
    # 공용
    project   = local.project
    region    = local.region
    uptime_L  = local.uptime_L
    uptime_S  = local.uptime_S
    TYPE      = local.TYPE
    TEAM      = local.TEAM

    # VPC
    AZz       = local.AZz
    Pub_net   = local.Pub_net
    Pri_net_A = local.Pri_net_A
    Pri_net_C = local.Pri_net_C
}