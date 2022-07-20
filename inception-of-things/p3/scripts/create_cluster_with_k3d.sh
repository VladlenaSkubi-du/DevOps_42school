#!/bin/bash

NAME="fullcdargocdVM"

echo "[INFO] Starting the cluster as docker container using k3d"
sudo /usr/local/bin/k3d cluster create $NAME --config /tmp/confs/confs/k3d_create_cluster.yml
sleep 10
sudo /usr/local/bin/k3d kubeconfig merge $NAME --output /tmp/confs/kubeconfig.yml

echo "[INFO] Creating namespaces according to the subject"
sudo ./kubectl create namespace argocd
sudo ./kubectl create namespace dev

echo "[INFO] Cluster information to add in host ~/.kube/config"
sudo ./kubectl cluster-info
sudo ./kubectl config view
ifconfig enp0s8

