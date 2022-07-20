#!/bin/bash

echo "[INFO] Starting argocd agent in argocd namespace"
sudo ./kubectl apply -n argocd -f /tmp/confs/confs/argocd_install_insecure_added.yml # downloaded to argocd_install.yml from https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml and changed
sleep 40
sudo ./kubectl wait -n argocd --for=condition=Ready pods --all
sudo ./kubectl wait -n argocd --for=condition=Ready pods --all
sudo ./kubectl apply -f /tmp/confs/confs/argocd_ingress.yml
sleep 10
echo "[INFO] Argocd server is created, please go to localhost:18080 and enter Argocd UI with admin and password:"
echo -e "\033[1;32m$(sudo ./kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo)\033[0m"
sleep 20

echo "[INFO] Starting application: argocd will syncronize cluster and git-repo"
sudo ./kubectl apply -f /tmp/confs/confs/argocd_application.yml
sleep 5