############################# ~/PROD/env.hcl
############################# for PROD_locals env
locals{
    # 공용
    project     = "MIR"
    uptime_L    = formatdate("YYYY-MM-DD'T 'hh:mm", timeadd(timestamp(), "9h"))
    uptime_S    = formatdate("hhmm", timeadd(timestamp(), "9h"))
    TYPE        = "NONE" # PROD*
    region      = "ap-northeast-2" # 도쿄

    # vpc
    AZz       = ["a", "c"]
    Pub_net   = [10, 20]
    Pri_net_A = [11, 12, 13]
    Pri_net_C = [21, 22, 23]
}