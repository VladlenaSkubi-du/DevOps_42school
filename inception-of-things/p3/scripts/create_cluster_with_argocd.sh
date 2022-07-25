#!/bin/bash

# k3d: https://k3d.io/v5.4.1/usage/exposing_services/
# argocd: https://argo-cd.readthedocs.io/en/stable/getting_started/

NAME="argocd-p3"

echo "Create k3d cluster with mounting 8888 of docker container to 8888 host port"
k3d cluster create $NAME -p "8888:8888@loadbalancer"

echo "Create namespaces"
kubectl create namespace argocd
kubectl create namespace dev

echo "Create argocd agent"
kubectl apply -n argocd -f confs/argocd_install.yml
kubectl wait -n argocd --for=condition=Ready pods --all
kubectl wait -n argocd --for=condition=Ready pods --all
kubectl wait -n argocd --for=condition=Ready pods --all
kubectl wait -n argocd --for=condition=Ready pods --all

echo "Make port-forwarding in other terminal to get argocd server: kubectl port-forward svc/argocd-server -n argocd 4242:443"
echo "Password to enter argocd server UI"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

echo "Create application"
kubectl apply -n argocd -f confs/argocd_application.yml
kubectl wait -n argocd --for=condition=Ready pods --all
kubectl wait -n argocd --for=condition=Ready pods --all
kubectl wait -n argocd --for=condition=Ready pods --all
kubectl wait -n argocd --for=condition=Ready pods --all