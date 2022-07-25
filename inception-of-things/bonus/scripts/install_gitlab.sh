#!/bin/bash

# https://docs.gitlab.com/charts/development/minikube/

echo "Starting minikube"
minikube start --memory 8192 --cpus 5 --kubernetes-version v1.18.2 --driver=virtualbox
minikube addons enable ingress

echo "Create namespace"
kubectl create namespace gitlab

echo "Install gitlab with Helm"
helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
--set global.edition=ce \
--timeout 600s \
-f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml \
--set global.hosts.domain=$(minikube ip).nip.io \
--set global.hosts.externalIP=$(minikube ip) \
-n gitlab

echo "Wait for 15 minutes for gitlab to be ready"
sleep 15m

echo "GitLab URL = https://gitlab.$(minikube ip).nip.io"
echo "PASSWORD for ROOT:"
kubectl get secret -n gitlab gitlab-gitlab-initial-root-password -ojsonpath='{.data.password}' | base64 --decode ; echo

## Commands
# kubectl get all
# minikube dashboard
# kubectl wait --for=condition=ready deployments gitlab-webservice-default -n gitlab

## In case of problems
# helm uninstall gitlab -n gitlab
# kubectl delete ns gitlab
# minikube stop
# minikube delete
