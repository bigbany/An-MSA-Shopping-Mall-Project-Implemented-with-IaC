#!/bin/bash

sudo apt-get update
sudo apt install  apt-transport-https ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install containerd.io -y

mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

cd /etc/containerd

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/g' config.toml

cd ~/

sudo systemctl restart containerd
#sudo systemctl status containerd

ls -l  /run/containerd/containerd.sock
