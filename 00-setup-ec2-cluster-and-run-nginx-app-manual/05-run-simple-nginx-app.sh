#!/bin/bash
# Create a new deployment for nginx image
kubectl create deployment nginx --image=nginx
kubectl get deployments
kubectl describe deployment nginx

# Create a new service for nginx deployment
kubectl create service nodeport nginx --tcp=80:80
kubectl get services

# get pods a nodes
kubectl get pods -o wide
kubectl get nodes

# connect to the app
curl http://worker-node-ip:app-port
curl 10.103.123.252:30085
