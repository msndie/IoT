#!/bin/bash

echo "[SCRIPT] Install k3s"
curl -sfL https://get.k3s.io/ | sh -s - --write-kubeconfig-mode 644
sleep 1
echo "[SCRIPT] applying manifests"
kubectl apply -f /vagrant/confs
echo "[SCRIPT] DONE!"
