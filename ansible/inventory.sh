#!/bin/bash
cd "$(dirname "$0")/../tofu"
IP=$(tofu output -raw instance_ip)
cd - > /dev/null

cat << ENDJSON
{
  "managers": {
    "hosts": ["$IP"],
    "vars": {
      "ansible_user": "ubuntu",
      "ansible_ssh_private_key_file": "/root/.ssh/id_rsa",
      "ansible_python_interpreter": "/usr/bin/python3"
    }
  },
  "workers": {
    "hosts": [],
    "vars": {}
  },
  "_meta": {
    "hostvars": {}
  }
}
ENDJSON
