#!/bin/bash

echo "[INFO] Updating package manager"
yes | sudo apt-get update
echo "[INFO] Installing docker"
yes | sudo apt-get install ca-certificates \
    curl \
    gnupg \
    lsb-release
yes | sudo apt-get install docker
yes | sudo apt-get install docker.io
# sudo usermod -aG docker $USER
echo "[INFO] Installing k3d"
sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
echo "export PATH=$PATH:$HOME" >> $HOME/.bashrc
