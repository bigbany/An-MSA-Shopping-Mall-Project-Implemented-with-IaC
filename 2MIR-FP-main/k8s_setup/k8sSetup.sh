#!/bin/bash

### 관련 파일은 git를 통해 설치
# 각 노드의 역할, 숫자에 맞게 호스트 네임 정하기
myPriIP=$(ip addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | awk -F'.' '{print $3"."$4}')
if ["$myPriIP" = "10.10"]; then
    # 마스터 노드
    sudo hostnamectl hostname k8s-MASTER
else
    # 워커 노드
    sudo hostnamectl hostname k8s-WORKER$myPriIP
fi

### 변수 선언
hostname=$(hostname)


### [공통 작업] 호스트 파일에 노드 ip, name 추가
sudo sh -c 'cat >> /etc/hosts <<EOF
172.16.11.10 k8s-MASTER
172.16.11.101 k8s-WORKER1
172.16.21.101 k8s-WORKER2
EOF'

### [공통 작업] k8s setup dir 생성 후 관련 파일 생성
echo "cp *.sh ~/k8sSetup"
mkdir ~/k8sSetup;
find . -maxdepth 1 -type f -name "*.sh" ! -name "k8sSetup.sh" -exec cp {} ~/k8sSetup/ \;

### [공통 작업] *.sh 실행
echo "create iptableset.sh"
sh ~/k8sSetup/iptableset.sh
sh ~/k8sSetup/dockercreate.sh
sh ~/k8sSetup/installkubeadm.sh


###### 노드 역할에 따른 *.sh 설치 진행
if [ "$hostname" = "K8S-MASTER" ]; then
    # 마스터 노드 진행
    sh kubeadminit.sh
    sh calicosetup.sh
    sleep 120
    sh calico-setting.sh

else 
    # 워커 노드 진행 
    echo "마스터 노드에서 생성된 kubeadm join 실행 필요" 
fi 
