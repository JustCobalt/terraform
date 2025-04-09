output "floating_ip" {
  value = openstack_networking_floatingip_v2.fip.address
}

output "ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa ubuntu@${openstack_networking_floatingip_v2.fip.address}"
}