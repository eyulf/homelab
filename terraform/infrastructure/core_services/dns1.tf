resource "random_password" "dns1" {
  length  = 32
  special = false
}

module "dns1" {
  source  = "eyulf/libvirt-virtual-machine/module"
  version = "1.0.0"

  providers = {
    libvirt = libvirt.kvm1
  }

  hostname = "dns1"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.kvm1_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.kvm1_os_images["debian_10"]

  network_ip_address     = "10.1.1.31"
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.dns1.result
  host_admin_users   = local.host_admin_users
}
