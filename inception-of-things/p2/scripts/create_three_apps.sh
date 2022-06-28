#!/bin/bash

echo "[INFO] Update packages on $1"
sudo yum update -y

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Install net-tools on $1"
    sudo yum install net-tools -y # download ifconfig
fi

export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

k3s=$(which k3s)
if [ -z "$k3s" ]
then
    echo "[INFO] Install k3s and set $1 as server"
    curl -sfL https://get.k3s.io | sh -s - server --node-ip $1 --tls-san $1 --node-external-ip $1
    # Problem: WARN[0014] Unable to read /etc/rancher/k3s/k3s.yaml, please start server with --write-kubeconfig-mode to modify kube config permissions 
    mkdir -p /home/vagrant/.kube # ignore command if directory exists
    sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config && \
        sudo chown vagrant /home/vagrant/.kube/config && \
        sudo chmod 600 /home/vagrant/.kube/config && \
        echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc
        echo "alias k=\"k3s kubectl\"" >> /home/vagrant/.bashrc    
fi

echo "[INFO] Create ingress and application nodes on $1"
kubectl=$(which kubectl)
$kubectl create configmap app1 --from-file /tmp/confs/app1/index.html
$kubectl apply -f /tmp/confs/app1/deployment_and_service.yml
$kubectl create configmap app2 --from-file /tmp/confs/app2/index.html
$kubectl apply -f /tmp/confs/app2/deployment_and_service.yml
$kubectl create configmap app3 --from-file /tmp/confs/app3/index.html
$kubectl apply -f /tmp/confs/app3/deployment_and_service.yml
$kubectl apply -f /tmp/confs/ingress.yml

# kubectl apply -f /tmp/confs/app1_conf.yml
# kubectl delete deployment --all