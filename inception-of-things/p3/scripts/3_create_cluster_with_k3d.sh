#!/bin/bash

NAME="p3fullcdargocdVM"
IP_ADDRESS=$(hostname -I | cut -d' ' -f 2)

echo "[INFO] Change ip address for TLS certificate in k3d configuration"
CONF_FILE="/tmp/confs/confs/k3d_create_cluster.yml"
OLD_IP_ADDRESS=$(grep tls-san $CONF_FILE | cut -d'=' -f 2)
sudo /usr/bin/sed -i -e "s/$OLD_IP_ADDRESS/$IP_ADDRESS/" $CONF_FILE
sleep 5

echo "[INFO] Starting docker"
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
