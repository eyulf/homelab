resource "random_password" "k8s-worker-01" {
  length  = 32
  special = false
}

module "k8s-worker-01" {
  source    = "../../modules/kvm_virtual_machine"
  providers = {
    libvirt = libvirt.kvm1
  }

  vcpus  = 2
  memory = "12288" # 12GB

  hostname = "k8s-worker-01"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.kvm1_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.kvm1_os_images[var.virtual_machines.k8s-worker-01.os]

  network_ip_address     = var.virtual_machines.k8s-worker-01.ip
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.k8s-worker-01.result
  host_admin_users   = var.host_admin_users
}
