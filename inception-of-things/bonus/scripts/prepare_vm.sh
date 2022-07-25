echo "[INFO] Update packages"
sudo yum update -y
export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

ifconfig=$(which ifconfig)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Install net-tools"
    sudo yum install net-tools -y # download ifconfig
fi

ifconfig=$(which docker)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Installing docker"
    sudo yum install -y yum-utils
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo -y
    sudo yum install docker-ce docker-ce-cli containerd.io -y
fi
echo "[INFO] Starting docker"
sudo chmod 666 /var/run/docker.sock
sudo systemctl start docker

ifconfig=$(which k3d)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Installing k3d"
    sudo curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
fi

ifconfig=$(which kubectl)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Installing kubectl to the current directory"
    sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo mv kubectl /usr/local/bin/
    sudo chmod +x /usr/local/bin/kubectl
fi

ifconfig=$(which helm)
if [ -z "$ifconfig" ]
then
    echo "[INFO] Installing helm"
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo "[INFO] Installing browser"
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap
snap install midori

