#!/bin/bash
set -e

echo "=== Etape 1 : Provisioning de l infrastructure ==="
cd tofu
tofu apply -auto-approve
export NODE_IP=$(tofu output -raw instance_ip)
cd ..

echo "=== Etape 2 : Attente SSH sur $NODE_IP ==="
echo "Attente du demarrage de la VM..."
until nc -zvw5 $NODE_IP 22; do
  sleep 5
done
echo "SSH est disponible !"

echo "=== Etape 3 : Deploiement avec Ansible (IP dynamique) ==="
export ANSIBLE_HOST_KEY_CHECKING=False
cd ansible
ansible-playbook -i inventory.sh playbook.yml
cd ..

echo "=== Deploiement termine ! ==="
echo "Dashboard Traefik : http://$NODE_IP:8080"
echo "Application whoami : http://whoami.$NODE_IP.traefik.me"
