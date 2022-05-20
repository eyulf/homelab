data "terraform_remote_state" "hypervisors" {
  backend = "local"

  config = {
    path = "../hypervisors/terraform.tfstate"
  }
}

provider "libvirt" {
  alias = "kvm1"
  uri   = "qemu+ssh://${var.hypervisor_hosts.kvm1.user}@${var.hypervisor_hosts.kvm1.ip}/system"
}

provider "libvirt" {
  alias = "kvm2"
  uri   = "qemu+ssh://${var.hypervisor_hosts.kvm2.user}@${var.hypervisor_hosts.kvm2.ip}/system"
}

provider "libvirt" {
  alias = "kvm3"
  uri   = "qemu+ssh://${var.hypervisor_hosts.kvm3.user}@${var.hypervisor_hosts.kvm3.ip}/system"
}
