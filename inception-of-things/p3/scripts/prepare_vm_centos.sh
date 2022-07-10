#!/bin/bash
# $ cat /etc/centos-release
# CentOS Linux release 7.9.2009 (Core)

echo "[INFO] Installing docker"
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
sudo yum install docker-ce -y
sudo systemctl start docker

echo "[INFO] Installing k3d"
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
echo "export PATH=$PATH:$HOME" >> $HOME/.bashrc

echo "[INFO] Starting the cluster with dev and argocd namespaces"
k3d cluster create fullcdargocd
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl port-forward svc/argocd-server 8080:443 -n argocd
