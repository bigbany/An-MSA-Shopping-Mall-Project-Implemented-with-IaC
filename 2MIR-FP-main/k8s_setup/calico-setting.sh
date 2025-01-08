#!/bin/bash
curl -L https://github.com/projectcalico/calico/releases/latest/download/v3.26.1/calicoctl-linux-amd64 -o calicoctl
chmod +x ./calicoctl
sudo mv ./calicoctl /usr/bin

cat << 'EOF' >> ~/.bashrc
export PATH="/usr/bin/calicoctl:$PATH"
EOF;
~/.bashrc

calicoctl get ippool -o wide

calicoctl get ippool default-ipv4-ippool -o yaml > calico-ipool.yaml

sed -i 's/ipipMode: Never/ipipMode: Always/g' calico-ipool.yaml
sed -i 's/vxlanMode: CrossSubnet/vxlanMode: Never/g' calico-ipool.yaml

calicoctl apply -f calico-ipool.yaml
#calicoctl get ippool -o wide
