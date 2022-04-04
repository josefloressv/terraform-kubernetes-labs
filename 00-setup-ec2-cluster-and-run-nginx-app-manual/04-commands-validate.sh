#!/bin/bash

# alll > verify the installation
kubectl version --client && kubeadm version

# master > Check Status
kubectl get pods --all-namespaces

# master: Check component's health/status
kubectl get componentstatus #(or kubectl get cs)

# maseter > get nodes
kubectl get nodes

