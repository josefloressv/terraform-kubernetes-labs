#! /bin/bash

# setup hostname
sudo hostnamectl set-hostname kube-master

# t2.micro does'n work
#[ERROR NumCPU]: the number of available CPUs 1 is less than the required 2
#[ERROR Mem]: the system RAM (968 MB) is less than the minimum 1700 MB

# Initialize Kubernetes Master Node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16


# Create Kubernetes Config as advised
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Setup Flannel Networking
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

# Allow firewall rule to create exceptions for port 6443 (default port for Kubernetes)
sudo ufw allow 6443
sudo ufw allow 6443/tcp

