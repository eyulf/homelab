provider "libvirt" {
  alias = "kvm2"
  uri   = "qemu+ssh://${local.hypervisor_hosts.kvm2.user}@${local.hypervisor_hosts.kvm2.ip}/system"
}

resource "libvirt_pool" "kvm2" {
  provider = libvirt.kvm2

  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_network" "kvm2" {
  provider = libvirt.kvm2

  name      = "default"
  mode      = "nat"
  domain    = "default"
  addresses = ["0.0.0.0/0"]
  autostart = true
}

resource "libvirt_volume" "kvm2_os_images" {
  for_each = var.os_images

  provider = libvirt.kvm2

  name   = "${replace(each.key, "_", "-")}.${var.os_image_format}"
  pool   = libvirt_pool.kvm2.name
  source = each.value
  format = var.os_image_format
}

output "kvm2_pool_name" {
  value = libvirt_pool.kvm3.name
}

output "kvm2_os_images" {
  value = {
    for os, volume in libvirt_volume.kvm2_os_images : os => volume.id
  }
}
