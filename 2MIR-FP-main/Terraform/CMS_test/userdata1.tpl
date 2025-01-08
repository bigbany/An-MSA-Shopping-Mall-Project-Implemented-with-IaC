#!/bin/bash -ex
sudo apt update -y && sudo apt install git -y
git clone https://github.com/2MIRACLE-BTC/2MIR-FP.git
cd 2MIR-FP/k8s_setup
sh k8sSetup.sh
