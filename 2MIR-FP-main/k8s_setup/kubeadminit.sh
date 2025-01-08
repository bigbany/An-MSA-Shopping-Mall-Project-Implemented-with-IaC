#!/bin/bash

sudo kubeadm init --token-ttl 0 --pod-network-cidr=192.168.0.0/16 --cri-socket unix:///var/run/containerd/containerd.sock >> kubeadm-init-result.txt

while true; do
    if grep -q "Your Kubernetes control-plane has initialized successfully" kubeadm-init-result.txt; then
        echo "kubeadm init completed successfully"
        break
    else
        echo "Waiting for kubeadm init to complete..."
        sleep 10
    fi
done

cat kubeadm-init-result.txt | tail -10 > k8s-token.txt

sudo rm -f kubeadm-init-result.txt

mkdir -p $HOME/.kube
sudo rm -f $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config