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
    for_each = var.port_names
    content {
      port = network.value
    }
  }
}
