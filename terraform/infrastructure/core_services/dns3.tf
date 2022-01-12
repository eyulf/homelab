resource "random_password" "dns3" {
  length  = 32
  special = false
}

module "dns3" {
  source    = "../../modules/kvm_virtual_machine"
  providers = {
    libvirt = libvirt.kvm3
  }

  vcpus = 1

  hostname = "dns3"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.kvm3_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.kvm3_os_images[var.virtual_machines.dns3.os]

  network_ip_address     = var.virtual_machines.dns3.ip
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.dns3.result
  host_admin_users   = var.host_admin_users
}
