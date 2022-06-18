resource "random_password" "k8s-controller-02" {
  length  = 32
  special = false
}

module "k8s-controller-02" {
  source  = "eyulf/libvirt-virtual-machine/module"
  version = "1.0.0"

  providers = {
    libvirt = libvirt.kvm2
  }

  vcpus = 2

  hostname = "k8s-controller-02"
  domain   = var.domain

  cloudinit_pool_name = data.terraform_remote_state.hypervisors.outputs.kvm2_pool_name
  disk_base_volume_id = data.terraform_remote_state.hypervisors.outputs.kvm2_os_images["debian_10"]

  network_ip_address     = "10.1.1.42"
  network_gateway_ip     = var.network_gateway_ip
  network_nameserver_ips = var.network_nameserver_ips

  host_root_password = random_password.k8s-controller-02.result
  host_admin_users   = local.host_admin_users
}
