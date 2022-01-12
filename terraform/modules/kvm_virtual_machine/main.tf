# CloudInit

resource "libvirt_cloudinit_disk" "cloudinit" {
  name = "${local.fqdn}-cloudinit.iso"
  pool = var.cloudinit_pool_name

  user_data = templatefile(
    "${path.module}/${local.cloudinit_template}",
    {
      hostname      = var.hostname
      fqdn          = local.fqdn
      admin_users   = var.host_admin_users
      admin_groups  = var.host_admin_groups
      root_password = var.host_root_password
    })

  network_config = templatefile(
    "${path.module}/network_config.cfg",
    {
      ip_address   = var.network_ip_address
      subnet_mask  = var.network_subnet
      gateway_ip   = var.network_gateway_ip
      name_servers = var.network_nameserver_ips
      domain       = var.domain
    })
}

# VM

resource "libvirt_volume" "main" {
  name           = "${local.fqdn}.qcow2"
  base_volume_id = var.disk_base_volume_id
  size           = var.disk_size
}

resource "libvirt_domain" "main" {
  name   = local.fqdn
  memory = var.memory
  vcpu   = var.vcpus

  cloudinit = libvirt_cloudinit_disk.cloudinit.id
  autostart = true

  disk {
    volume_id = libvirt_volume.main.id
  }

  network_interface {
    bridge   = var.network_bridge_name
    hostname = local.fqdn
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
