#!/bin/bash

# Arguments: [K3S_SERVER_IP]

echo "Update packages"
sudo yum update -y

export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    echo "Install net-tools to get ifconfig"
    sudo yum install net-tools -y
fi

k3s=$(which k3s)
if [ -z "$k3s" ]
then
    echo "[INFO] Install k3s and set VM as server"
    curl -sfL https://get.k3s.io | sh -s - server --node-ip $1 --tls-san $1
    mkdir -p /home/vagrant/.kube # ignore command if directory exists
    sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config && \
        sudo chown vagrant /home/vagrant/.kube/config && \
        sudo chmod 600 /home/vagrant/.kube/config && \
        echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc
        echo "alias k=\"k3s kubectl\"" >> /home/vagrant/.bashrc
fi

echo "Copying server token to host machine to create agents"
sudo cp /var/lib/rancher/k3s/server/node-token /tmp/p1/file_with_token