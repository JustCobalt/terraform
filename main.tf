terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.52.0"
    }
  }
}

provider "openstack" {}

resource "openstack_compute_keypair_v2" "default" {
  name       = "ma-cle-terraform"
  public_key = file("/home/debian/.ssh/id_rsa.pub")
}

resource "openstack_networking_network_v2" "private" {
  name           = "terraform-network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name            = "terraform-subnet"
  network_id      = openstack_networking_network_v2.private.id
  cidr            = "192.168.199.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8"]
}

resource "openstack_networking_router_v2" "router" {
  name                = "terraform-router"
  external_network_id = var.external_network_id
  enable_snat         = true
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = var.floating_ip_pool
}

resource "openstack_compute_instance_v2" "instance" {
  name            = "vm-terraform"
  image_name      = var.image_name
  flavor_name     = var.flavor_name
  key_pair        = openstack_compute_keypair_v2.default.name
  security_groups = ["default"]

  network {
    uuid = openstack_networking_network_v2.private.id
  }
}

resource "openstack_compute_floatingip_associate_v2" "fip_assoc" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.instance.id
}
