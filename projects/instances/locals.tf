locals {
  kis_os_region   = "RegionOne"
  kis_os_auth_url = "https://158.193.152.44:5000/v3/"
  #my_public_ip = "${data.http.my_public_ip.response_body}/32"
  my_public_ip = "/32"
  project      = lower("${var.tenant_name}-docker")
  kis_os_domain_name = "admin_domain"
  kis_os_endpoint_overrides = {
    compute = "https://158.193.152.44:8774/v2.1/"
    image   = "https://158.193.152.44:9292/v2.0/"
    network = "https://158.193.152.44:9696/v2.0/"
  }

  image = {
    ubuntu = {
      name        = "ubuntu-22.04-KIS"
      os_username = "ubuntu"
    }
    debian = {
      name        = "debian-12"
      os_username = "debian"
    }
  }
}
