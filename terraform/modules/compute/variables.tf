variable "ports" {
  type = list(object({
    name       = string
    network_id = string
    fixed_ips  = optional(list(object({
      ip_address = string
      subnet_id  = string
    })))
  }))
}

variable "project" {
  type = string
}
variable "environment" {
  type = string
}
variable "name" {
  type = string
}

variable "my_public_ip" {
  type = string
}

variable "key_pair_name" {
  type = string
}

variable "user_data" {
  type = string
}

variable "flavor_name" {
  type = string
}

variable "image_name" {
  type = string
}

# Default: ext-net (public network -> instance is connected to the public internet)
variable "network_name" {
  type    = string
  default = "ext-net"
}

