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
