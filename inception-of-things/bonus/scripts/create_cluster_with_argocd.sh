#!/bin/bash

# k3d: https://k3d.io/v5.4.1/usage/exposing_services/
# argocd: https://argo-cd.readthedocs.io/en/stable/getting_started/

NAME="bonus_iot"

echo "Create k3d cluster with mounting 8888 of docker container to 8888 host port"
k3d cluster create $NAME --api-port 6443 -p "8080:80@loadbalancer" -p "8888:8888@loadbalancer" --agents 2

echo "Create namespaces"
kubectl create namespace argocd
kubectl create namespace dev

echo "Create argocd agent"
kubectl apply -n argocd -f confs/argocd_install_insecure_added.yml # downloaded to argocd_install.yml from https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml and changed
while ! kubectl wait -n argocd --for=condition=Ready pods --all; do; done
kubectl apply -n argocd -f confs/argocd_ingress.yml

echo "Password to enter argocd server UI"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo "Create application"
kubectl apply -n argocd -f confs/argocd_project.yml 
kubectl apply -n argocd -f confs/argocd_application.yml
while ! kubectl wait -n dev --for=condition=Ready pods --all; do; done