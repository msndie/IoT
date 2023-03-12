#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}[SCRIPT] Please run as root${NC}"
  exit
fi

echo -e "${YELLOW}[SCRIPT] Creating cluster and waiting${NC}"
k3d cluster create dev-cluster --k3s-arg "--disable=traefik@server:0" --api-port 6443 --port 8080:80@loadbalancer --port 8888:8888@loadbalancer --wait

sleep 5

echo -e "${YELLOW}[SCRIPT] Waiting for cluster to be ready${NC}"
kubectl wait --for=condition=Ready pods --all -n kube-system

echo -e "${YELLOW}[SCRIPT] Creating namespaces${NC}"
kubectl create namespace argocd
kubectl create namespace dev

echo -e "${YELLOW}[SCRIPT] Applying argocd manifests${NC}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

sleep 5

echo -e "${YELLOW}[SCRIPT] Waiting for argocd to be ready${NC}"
kubectl wait --for=condition=Ready pods --all -n argocd

echo -e "${YELLOW}[SCRIPT] Applying argocd project and application manifests${NC}"
kubectl apply -n argocd -f ../confs

echo -e "${YELLOW}[SCRIPT] Patching argocd-server service${NC}"
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

echo -e "${YELLOW}[SCRIPT] Waiting for argocd to be ready${NC}"
kubectl wait --for=condition=Ready pods --all -n argocd

echo -e "${YELLOW}[SCRIPT] Retrieving password for argocd${NC}"
pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "${YELLOW}Password is ${GREEN}$pass${NC}"