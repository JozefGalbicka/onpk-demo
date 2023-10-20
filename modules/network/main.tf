resource "openstack_networking_network_v2" "net" {
  name  = var.name
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "net" {
  name  = var.name
  network_id = openstack_networking_network_v2.net.id
  cidr       = var.cidr
  ip_version = 4
  #dns_nameservers = [ "8.8.8.8", "1.1.1.1" ]
}

