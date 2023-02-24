#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}[SCRIPT] Please run as root${NC}"
  exit
fi

echo -e "${YELLOW}[SCRIPT] Creating cluster${NC}"
k3d cluster create dev-cluster --api-port 6443 -p 8080:80@loadbalancer --agents 2 --wait

echo -e "${YELLOW}[SCRIPT] Creating namespaces${NC}"
kubectl create namespace argocd
kubectl create namespace dev

echo -e "${YELLOW}[SCRIPT] Applying argocd manifests${NC}"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo -e "${YELLOW}[SCRIPT] Waiting for argocd to be ready${NC}"
kubectl wait --for=condition=Ready pods --all -n argocd

# echo -e "${YELLOW}[SCRIPT] Applying manifests${NC}"
# kubectl apply -n argocd -f ../confs/ingress.yaml

# echo -e "${YELLOW}[SCRIPT] Waiting for argocd to be ready${NC}"
# kubectl wait --for=condition=Ready pods --all -n argocd

echo -e "${YELLOW}[SCRIPT] Applying argocd project manifest${NC}"
kubectl apply -n argocd -f ../confs/project.yaml

echo -e "${YELLOW}[SCRIPT] Port forwarding${NC}"
kubectl port-forward svc/argocd-server -n argocd 8080:443

echo -e "${YELLOW}[SCRIPT] Retrieving password for argocd${NC}"
pass=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
echo -e "${YELLOW}Password is ${GREEN}$pass${NC}"