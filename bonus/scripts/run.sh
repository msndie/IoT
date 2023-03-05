#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ "$EUID" -ne 0 ]
  then echo -e "${RED}[SCRIPT] Please run as root${NC}"
  exit
fi

HELM=/usr/local/bin/helm
if [ -f "$HELM" ]; then
    echo -e "${RED}[SCRIPT] helm already installed${NC}"
else
    echo -e "${YELLOW}[SCRIPT] Installing helm${NC}"
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

echo -e "${YELLOW}[SCRIPT] Creating namespaces${NC}"
kubectl create namespace gitlab

echo -e "${YELLOW} Deploying gitlab${NC}"
helm install gitlab https://gitlab-charts.s3.amazonaws.com/gitlab-6.9.2.tgz \
  -n gitlab \
  -f https://gitlab.com/gitlab-org/charts/gitlab/raw/master/examples/values-minikube-minimum.yaml
  --timeout 600s \
  --set global.hosts.domain=example.com \
  --set global.hosts.externalIP=localhost \
  --set global.edition=ce

echo -e "${YELLOW} Waiting for gitlab${NC}"
sudo kubectl wait --for=condition=available deployments --all -n gitlab