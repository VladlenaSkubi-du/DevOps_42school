#!/bin/bash

echo "[INFO] Starting argocd agent in argocd namespace"
/usr/local/bin/kubectl apply -n argocd -f /tmp/confs/confs/argocd_install_insecure_added.yml # downloaded to argocd_install.yml from https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml and changed
for (( i = 0; i < 5; i++ ))
do
    /usr/local/bin/kubectl wait -n argocd --for=condition=Ready pods --all
done
/usr/local/bin/kubectl apply -n argocd -f /tmp/confs/confs/argocd_ingress.yml
sleep 20

echo "[INFO] Argocd server is created, please go to localhost:48080 and enter Argocd UI with admin and password:"
echo -e "\033[1;32m$(/usr/local/bin/kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo)\033[0m"
sleep 20

echo "[INFO] Starting project: argocd will syncronize cluster and git-repo"
/usr/local/bin/kubectl apply -n argocd -f /tmp/confs/confs/argocd_project.yml 
sleep 5

echo "[INFO] Starting application: argocd will syncronize cluster and git-repo"
/usr/local/bin/kubectl apply -n argocd -f /tmp/confs/confs/argocd_application.yml
for (( i = 0; i < 2; i++ ))
do
    /usr/local/bin/kubectl wait -n dev --for=condition=Ready pods --all
done
sleep 5

# In case of problems:
# /usr/local/bin/k3d cluster stop $NAME
# sudo systemctl restart docker
# /usr/local/bin/k3d cluster start $NAME
# Also:
# /usr/local/bin/k3d cluster delete $NAME ; sudo rm -f /tmp/confs/kubeconfig.yml