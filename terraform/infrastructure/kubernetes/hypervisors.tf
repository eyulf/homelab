data "terraform_remote_state" "hypervisors" {
  backend = "local"

  config = {
    path = "../hypervisors/terraform.tfstate"
  }
}

data "sops_file" "hypervisors" {
  source_file = "../hypervisors/hypervisors.yaml"
}

provider "libvirt" {
  alias = "kvm1"
  uri   = "qemu+ssh://${data.sops_file.hypervisors.data["kvm1.user"]}@${data.sops_file.hypervisors.data["kvm1.ip"]}/system"
}

provider "libvirt" {
  alias = "kvm2"
  uri   = "qemu+ssh://${data.sops_file.hypervisors.data["kvm2.user"]}@${data.sops_file.hypervisors.data["kvm2.ip"]}/system"
}

provider "libvirt" {
  alias = "kvm3"
  uri   = "qemu+ssh://${data.sops_file.hypervisors.data["kvm3.user"]}@${data.sops_file.hypervisors.data["kvm3.ip"]}/system"
}
