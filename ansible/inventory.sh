#!/bin/bash
cd "$(dirname "$0")/../tofu"
MANAGER_IP=$(tofu output -raw manager_ip)
WORKER_IP=$(tofu output -raw worker_ip)
cd - > /dev/null

cat << ENDJSON
{
  "managers": {
    "hosts": ["$MANAGER_IP"],
    "vars": {
      "ansible_user": "ubuntu",
      "ansible_ssh_private_key_file": "~/.ssh/id_rsa",
      "ansible_python_interpreter": "/usr/bin/python3"
    }
  },
  "workers": {
    "hosts": ["$WORKER_IP"],
    "vars": {
      "ansible_user": "ubuntu",
      "ansible_ssh_private_key_file": "~/.ssh/id_rsa",
      "ansible_python_interpreter": "/usr/bin/python3"
    }
  },
  "_meta": {
    "hostvars": {}
  }
}
ENDJSON
