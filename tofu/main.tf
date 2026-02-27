terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53"
    }
  }
  backend "s3" {
    bucket                      = "tp-iac-hr60"
    key                         = "terraform.tfstate"
    region                      = "gra"
    endpoint                    = "https://s3.gra.perf.cloud.ovh.net"
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "vm_swarm" {
  count       = 2
  name        = "vm-iac-tp-${count.index}"
  image_name  = "Ubuntu 22.04"
  flavor_name = "d2-2"
  key_pair    = "ma-cle-wsl"

  network {
    name = "Ext-Net"
    uuid = "b2c02fdc-ffdf-40f6-9722-533bd7058c06"
  }

  security_groups = ["default"]
}

output "instances_ips" {
  value = openstack_compute_instance_v2.vm_swarm[*].access_ip_v4
}

output "manager_ip" {
  value = openstack_compute_instance_v2.vm_swarm[0].access_ip_v4
}

output "worker_ip" {
  value = openstack_compute_instance_v2.vm_swarm[1].access_ip_v4
}
