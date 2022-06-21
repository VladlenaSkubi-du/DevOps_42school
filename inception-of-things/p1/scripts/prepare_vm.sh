#!/bin/bash

sudo yum update -y

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    sudo yum install net-tools -y # download ifconfig
fi

k3s=$(which k3s)
if [ -z "$k3s" ]
then
    curl -sfL https://get.k3s.io | sh - # download k3s
    # Problem: WARN[0014] Unable to read /etc/rancher/k3s/k3s.yaml, please start server with --write-kubeconfig-mode to modify kube config permissions 
    mkdir .kube
    sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config && \
        sudo chown $USER $HOME/.kube/config && \
        sudo chmod 600 $HOME/.kube/config && \
        echo "export KUBECONFIG=$HOME/.kube/config" >> $HOME/.bashrc
    exec "$SHELL"
    alias k="kubectl"
fi

