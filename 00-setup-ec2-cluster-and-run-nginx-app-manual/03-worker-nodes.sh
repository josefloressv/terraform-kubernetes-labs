#!/bin/bash


# setup hostname
sudo hostnamectl set-hostname kube-worker-1
sudo hostnamectl set-hostname kube-worker-2

# join to the master
sudo kubeadm join 172.31.87.255:6443 --token 1qgc5k.nxbg7esmap4rogls \
        --discovery-token-ca-cert-hash sha256:xxxxxxxxxxxxxxxxxxxxx 
