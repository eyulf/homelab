provider "libvirt" {
  alias = "kvm3"
  uri   = "qemu+ssh://${data.sops_file.hypervisors.data["kvm3.user"]}@${data.sops_file.hypervisors.data["kvm3.address"]}/system"
}

resource "libvirt_pool" "kvm3" {
  provider = libvirt.kvm3

  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_network" "kvm3" {
  provider = libvirt.kvm3

  name      = "default"
  mode      = "nat"
  domain    = "default"
  addresses = ["0.0.0.0/0"]
  autostart = true
}

resource "libvirt_volume" "kvm3_os_images" {
  for_each = var.os_images

  provider = libvirt.kvm3

  name   = "${replace(each.key, "_", "-")}.${var.os_image_format}"
  pool   = libvirt_pool.kvm3.name
  source = each.value
  format = var.os_image_format
}

output "kvm3_pool_name" {
  value = libvirt_pool.kvm3.name
}

output "kvm3_os_images" {
  value = {
    for os, volume in libvirt_volume.kvm3_os_images : os => volume.id
  }
}
