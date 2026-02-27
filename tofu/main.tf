terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.53"
    }
  }
}

provider "openstack" {
  cloud = "openstack"
}

resource "openstack_compute_instance_v2" "server" {
  name        = "tp-server"
  image_name  = "Ubuntu 22.04"
  flavor_name = "d2-2"
  key_pair    = "ma-cle-wsl"
  
   network {
    name = "Ext-Net"
    uuid = "b2c02fdc-ffdf-40f6-9722-533bd7058c06"
  }  
  security_groups = ["default"]
}

output "instance_ip" {
  value = openstack_compute_instance_v2.server.access_ip_v4
}
