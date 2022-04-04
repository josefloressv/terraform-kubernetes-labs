#! /bin/bash
sudo apt update
sudo apt upgrade -y
#125MB, 3m
# necessary for download the kubenete key
sudo apt install apt-transport-https curl -y

# add the Kubernetes GPG key ant the Kubernetes repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# update the apt package index
sudo apt update

# install Kubernetes and necesary packages
sudo apt install -y git kubelet kubeadm kubectl kubernetes-cni -y
#77MB

# prevent kubernetest pakcages from being automatic updated
sudo apt-mark hold kubelet kubeadm kubectl kubernetes-cni

# disable swap
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

# Enable bridge traffic in IP tables
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl --system


# Docker setup
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io -y
#96.4MB

sudo usermod -aG docker $USER

# create required directories
sudo mkdir -p /etc/systemd/system/docker.service.d

# Create daemon json config file
sudo tee /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

# Start and enable Services
sudo systemctl daemon-reload 
sudo systemctl restart docker
sudo systemctl enable docker

# Reeboot the machine
sudo reboot
