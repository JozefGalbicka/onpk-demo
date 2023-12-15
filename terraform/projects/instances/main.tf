resource "openstack_compute_keypair_v2" "glbjzf_laptop" {
  name       = "glbjzf-laptop"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBNgVIPvOg4YRVONadB6V7C2+IKA5LVfe6LjdqgEdSlw glbjzf-laptop"
}

### NETWORK - EXT
data "openstack_networking_network_v2" "ext" {
  name           = "ext-net-154"
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
  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_docker"
    content      = file("${path.module}/scripts/docker.sh")
  }
  part {
    content_type = "text/x-shellscript"
    filename     = "userdata_minikube"
    content      = file("${path.module}/scripts/minikube.sh")
  }
}

module "network-internal" {
  source      = "../../modules/network"
  name           = "internal"
  cidr       = "172.22.1.0/24"
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
  image_name        = "ubuntu-22.04-KIS"
  #image_name    = "debian-12"
  user_data     = data.cloudinit_config.user_data_router.rendered
  ports      = [
    {
      name       = "router_ext"
      network_id = data.openstack_networking_network_v2.ext.id
    },
    {
      name = "router_int"
      network_id = module.network-internal.network_id
      fixed_ips = [
        {
          ip_address = "172.22.1.1"
          subnet_id  = module.network-internal.subnet_id
        }
      ]
    }
  ]
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
  image_name        = "ubuntu-22.04-KIS"
  #image_name    = "debian-12"
  user_data     = data.cloudinit_config.user_data_server.rendered
  ports      = [
    {
      name = "server_int"
      network_id = module.network-internal.network_id
      ip_address = "172.22.1.10"
      subnet_id  = module.network-internal.subnet_id
    }
  ]
}
