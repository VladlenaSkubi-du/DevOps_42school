#!/bin/bash
# Arguments: [K3S_AGENT1_IP, K3S_SERVER_IP, K3S_SERVER_TOKENFILE]

echo "[INFO] Update packages on $1"
sudo yum update -y

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Install net-tools on $1"
    sudo yum install net-tools -y # download ifconfig
fi

k3s=$(which k3s)
if [ -z "$k3s" ]
then
    echo "[INFO] Install k3s and set $1 as agent"
    curl -sfL https://get.k3s.io | K3S_URL=https://$2:$3 K3S_TOKEN_FILE=/tmp/confs/server_token sh -s - \
        --node-ip $1 # download k3s and set as server worker (or agent)
    # Problem: WARN[0014] Unable to read /etc/rancher/k3s/k3s.yaml, please start server with --write-kubeconfig-mode to modify kube config permissions 
    mkdir -p /home/vagrant/.kube # ignore command if directory exists
    sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config && \
        sudo chown vagrant /home/vagrant/.kube/config && \
        sudo chmod 600 /home/vagrant/.kube/config && \
        echo "export KUBECONFIG=/home/vagrant/.kube/config" >> /home/vagrant/.bashrc
        echo "alias k=\"k3s kubectl\"" >> /home/vagrant/.bashrc
fi
