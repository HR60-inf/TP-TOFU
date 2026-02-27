#!/bin/bash
set -e

echo "Étape 1 : Provisioning de l'infrastructure..."
cd tofu
tofu apply -auto-approve
export NODE_IP=$(tofu output -raw instance_ip)
cd -

echo "Étape 2: Attente du démarrage de SSH sur $NODE_IP..."
until nc -zv $NODE_IP 22; do
    echo "..."
    sleep 5
done

echo "SSH est disponible !"

echo "Étape 3 : Configuration logicielle avec Ansible..."
cd ansible
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -i inventory.sh playbook.yml
cd -

echo "Étape 4 : Déploiement des Stacks Docker..."
cd docker
export DOCKER_HOST=ssh://ubuntu@$NODE_IP
docker stack deploy -c traefik-stack.yml traefik
docker stack deploy -c app-whami-stack.yml whami
cd -
