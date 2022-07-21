#!/bin/bash

NAME="p3fullcdargocdVM"

sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker
echo "[INFO] Starting the cluster as docker container using k3d"
/usr/local/bin/k3d cluster create $NAME --config /tmp/confs/confs/k3d_create_cluster.yml
sleep 10
sudo /usr/local/bin/k3d kubeconfig merge $NAME --output /tmp/confs/kubeconfig.yml

echo "[INFO] Creating namespaces according to the subject"
/usr/local/bin/kubectl create namespace argocd
/usr/local/bin/kubectl create namespace dev

echo "[INFO] Cluster information to add in host ~/.kube/config"
/usr/local/bin/kubectl cluster-info
/usr/local/bin/kubectl config view
ifconfig enp0s8
