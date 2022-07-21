#!/bin/bash

echo "[INFO] Update packages"
sudo yum update -y

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Install net-tools to get ifconfig"
    sudo yum install net-tools -y
fi

export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

k3s=$(which k3s)
if [ -z "$k3s" ]
then
    echo "[INFO] Install k3s and set VM as server"
    curl -sfL https://get.k3s.io | sh -s - server --node-ip $1 --tls-san $1 --node-external-ip $1
    mkdir -p /home/vagrant/.kube # ignore command if directory exists
    sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config && \
        sudo chown vagrant /home/vagrant/.kube/config && \
        sudo chmod 600 /home/vagrant/.kube/config && \
        echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc
        echo "alias k=\"k3s kubectl\"" >> /home/vagrant/.bashrc    
fi

echo "[INFO] Create ingress and application nodes on VM"
kubectl=$(which kubectl)
$kubectl create configmap app-one --from-file /tmp/p2/app1_source/index.html
$kubectl create configmap app-two --from-file /tmp/p2/app2_source/index.html
$kubectl create configmap app-three --from-file /tmp/p2/app3_source/index.html
$kubectl apply -f /tmp/p2/apps_kubeconfigs
$kubectl wait --for=condition=Ready pods --all