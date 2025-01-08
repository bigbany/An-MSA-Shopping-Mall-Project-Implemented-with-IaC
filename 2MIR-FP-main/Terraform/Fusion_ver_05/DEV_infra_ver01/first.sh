#!/bin/bash

### git clone 이후 테라폼 최초 배포시 사용을 권장합니다 ###

### <KTS 시간 동기화>
echo "time check"
sudo ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
date
### </KTS 시간 동기화>

### <키페어 체크>
echo "Check mykey"
if [ -f "mykey" ] && [ -f "mykey.pub" ]; then
  ls | grep my
  echo "already key pairs. next process"
else
  echo "create mykey"
  ssh-keygen -m PEM -f mykey -N ""
  ls | grep my
fi
### </키페어 체크>

### <.terraform/ 체크>
if [ -d ".terraform" ]; then
	read -p ".terraform is exists. Do you want to continue? (Y/N): " choice
		case "$choice" in
			[Yy])
				echo "TF init -migrate-state"; terraform init -migrate-state;
				;;
			[Nn])
				echo "Exiting..."
				exit 1
				;;
			*)
				echo "Invalid choice. Exiting..."
				exit 1
				;;
		esac
	else
		echo "TF init"; terraform init;
fi
### </.terraform/ 체크>

### 배포 진행
# apply
terraform fmt;
terraform apply -auto-approve -target module.vpc;
terraform apply -auto-approve -target module.SG;
terraform apply -auto-approve -target module.global;
terraform apply -auto-approve -target module.mgmt;


### 삭제[각주 해제 금지] echo "TF destroy"; terraform destroy -auto-approve;