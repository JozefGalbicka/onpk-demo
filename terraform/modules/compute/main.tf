resource "openstack_networking_secgroup_v2" "security_group" {
  name        = "${var.project}-${var.environment}-secgroup"
  description = "Managed by Terraform!"
}


data "openstack_compute_flavor_v2" "flavor_id" {
  name = var.flavor_name
}

data "openstack_images_image_v2" "image_id" {
  #name = local.image.debian.name
  name = var.image_name
}

# Create Virtual Machine
resource "openstack_compute_instance_v2" "instance" {
  name            = "${var.project}-${var.environment}-${var.name}"
  image_id        = data.openstack_images_image_v2.image_id.id
  flavor_id       = data.openstack_compute_flavor_v2.flavor_id.id
  key_pair        = var.key_pair_name
  #security_groups = [openstack_networking_secgroup_v2.security_group.name]

  user_data = var.user_data

  dynamic "network" {
    for_each = openstack_networking_port_v2.instance
    content {
      port = network.value.id
    }
  }
}

resource "openstack_networking_port_v2" "instance" {
  for_each = { for port in var.ports: port.name => port }
  name           = each.value.name
  network_id     = each.value.network_id

  admin_state_up = "true"
  dynamic "fixed_ip" {
    for_each = coalesce(each.value.fixed_ips, []) # https://developer.hashicorp.com/terraform/language/functions/coalesce
    content {
      subnet_id  = fixed_ip.value.subnet_id
      ip_address = fixed_ip.value.ip_address
    }
  }
}
