provider "libvirt" {
  alias = "kvm1"
  uri   = "qemu+ssh://${ var.hypervisor_hosts.kvm1.user }@${ var.hypervisor_hosts.kvm1.ip }/system"
}

resource "libvirt_pool" "kvm1" {
  provider = libvirt.kvm1

  name = "default"
  type = "dir"
  path = "/var/lib/libvirt/images"
}

resource "libvirt_network" "kvm1" {
  provider = libvirt.kvm1

  name      = "default"
  mode      = "nat"
  domain    = "default"
  addresses = ["0.0.0.0/0"]
  autostart = true
}

resource "libvirt_volume" "kvm1_os_images" {
  for_each = var.os_images

  provider = libvirt.kvm1

  name   = "${replace(each.key, "_", "-")}.${var.os_image_format}"
  pool   = libvirt_pool.kvm1.name
  source = each.value
  format = var.os_image_format
}

output "kvm1_pool_name" {
  value = libvirt_pool.kvm3.name
}

output "kvm1_os_images" {
  value = {
    for os, volume in libvirt_volume.kvm1_os_images : os => volume.id
  }
}
