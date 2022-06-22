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
    curl -sfL https://get.k3s.io | sh -s - --token-file /tmp/token \
        --node-ip $1 # download k3s and set as server worker (or agent)
fi
