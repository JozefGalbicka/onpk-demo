resource "openstack_compute_keypair_v2" "glbjzf_laptop" {
  name       = "glbjzf-laptop"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNgVIPvOg4YRVONadB6V7C2+IKA5LVfe6LjdqgEdSlw glbjzf-laptop"
}

### NETWORK - EXT
data "openstack_networking_network_v2" "ext" {
  name           = "ext-net-154"
}

resource "openstack_networking_port_v2" "router_ext" {
  name           = "router-ext"
  network_id     = data.openstack_networking_network_v2.ext.id
  admin_state_up = "true"
}

### NETWORK - INT
resource "openstack_networking_network_v2" "int" {
  name           = "internal"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "int" {
  name       = "internal"
  network_id = openstack_networking_network_v2.int.id
  cidr       = "172.22.1.0/24"
  ip_version = 4
  #dns_nameservers = [ "8.8.8.8", "1.1.1.1" ]
}

resource "openstack_networking_port_v2" "router_int" {
  name           = "router-int"
  network_id     = openstack_networking_network_v2.int.id
  #network_id     = var.network_id

  admin_state_up = "true"
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.int.id
    ip_address = "172.22.1.1"
  }
}

resource "openstack_networking_port_v2" "server_int" {
  name           = "server-int"
  network_id     = openstack_networking_network_v2.int.id
  #network_id     = var.network_id

  admin_state_up = "true"
  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.int.id
    ip_address = "172.22.1.10"
  }
}

data "cloudinit_config" "user_data_router" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_base"
    content      = file("${path.module}/scripts/base.sh")
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_router"
    content      = file("${path.module}/scripts/router.sh")
  }
}

data "cloudinit_config" "user_data_server" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_base"
    content      = file("${path.module}/scripts/base.sh")
  }
}

### INSTANCE
module "instance-router" {
  source        = "../../modules/compute"
  project       = "onpk"
  environment   = "dev"
  name          = "router"
  my_public_ip  = "unused"
  #my_public_ip  = data.http.my_public_ip.response_body
  #key_pair_name = "glbjzf-laptop"
  key_pair_name = openstack_compute_keypair_v2.glbjzf_laptop.name
  flavor_name   = "1c05r8d"
  port_names    = [openstack_networking_port_v2.router_int.id, openstack_networking_port_v2.router_ext.id]
  image_name        = "ubuntu-22.04-KIS"
  #image_name    = "debian-12"
  user_data     = data.cloudinit_config.user_data_router.rendered
}

module "instance-server" {
  source        = "../../modules/compute"
  project       = "onpk"
  environment   = "dev"
  name          = "server"
  my_public_ip  = "unused"
  #my_public_ip  = data.http.my_public_ip.response_body
  #key_pair_name = "glbjzf-laptop"
  key_pair_name = openstack_compute_keypair_v2.glbjzf_laptop.name
  flavor_name   = "1c05r8d"
  port_names    = [openstack_networking_port_v2.server_int.id]
  image_name        = "ubuntu-22.04-KIS"
  #image_name    = "debian-12"
  user_data     = data.cloudinit_config.user_data_server.rendered
}
