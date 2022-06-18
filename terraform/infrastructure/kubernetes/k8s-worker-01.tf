resource "random_password" "k8s-worker-01" {
  length  = 32
  special = false
}

module "k8s-worker-01" {
  source  = "eyulf/libvirt-virtual-machine/module"
  version = "1.0.0"

  providers = {
    libvirt = libvirt.kvm1
  }

  vcpus = 2
  #memory = "12288" # 12GB

  hostname = "k8s-worker-01"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.kvm1_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.kvm1_os_images["debian_10"]

  additional_disks = {
    "openebs" = 429496524800, # 400 GB
  }

  network_ip_address     = "10.1.1.51"
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.k8s-worker-01.result
  host_admin_users   = local.host_admin_users
}
