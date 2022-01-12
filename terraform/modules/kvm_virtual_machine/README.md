# KVM Virtual Machine

## Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Requirements](#requirements)
- [Providers](#providers)
- [Modules](#modules)
- [Resources](#resources)
- [Inputs](#inputs)

## Introduction

This module will configure a single libvirt VM with minimal configuration done using [cloud-init](https://cloudinit.readthedocs.io/en/latest/).

Admin users are created with passwordless sudo privileges and server IPs are statically assigned using variables provided.

## Usage

```hcl
module "example" {
  source    = "path/to/module/kvm_virtual_machine"
  providers = {
    libvirt = libvirt
  }

  hostname = "example"
  domain   = "local.domain"

  cloudinit_pool_name = libvirt_pool.example.name
  disk_base_volume_id = libvirt_volume.example.id

  network_ip_address     = "192.168.1.2"
  network_gateway_ip     = "192.168.1.1"
  network_nameserver_ips = "192.168.1.1, 1.1.1.1, 1.0.0.1"

  host_root_password = "my-super-awesome-password"
  host_admin_users   = {
    "admin" = "ssh-rsa AA[...]ZZ==",
  }
}
```

---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.1 |
| libvirt | 0.6.12 |

## Providers

| Name | Version |
|------|---------|
| libvirt | 0.6.12 |

## Modules

No Modules.

## Resources

| Name |
|------|
| [libvirt_cloudinit_disk](https://registry.terraform.io/providers/dmacvicar/libvirt/0.6.12/docs/resources/cloudinit_disk) |
| [libvirt_domain](https://registry.terraform.io/providers/dmacvicar/libvirt/0.6.12/docs/resources/domain) |
| [libvirt_volume](https://registry.terraform.io/providers/dmacvicar/libvirt/0.6.12/docs/resources/volume) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudinit\_pool\_name | The pool used to build the CloudInit image. | `string` | n/a | yes |
| disk\_base\_volume\_id | The ID of the disk's base image. | `string` | n/a | yes |
| disk\_size | The size of the VM's disk in B. | `number` | `21474826240` | no |
| domain | The VM's domain that forms the FQDN. | `string` | n/a | yes |
| host\_admin\_groups | A comma seperated string of groups to add admin users to. | `string` | `"wheel"` | no |
| host\_admin\_users | A map of admin users to configure with their SSH Key. | `map(string)` | <pre>{<br>  "admin": "ssh-rsa AA[...]ZZ=="<br>}</pre> | no |
| host\_root\_password | The intial root password. | `string` | n/a | yes |
| hostname | The VM's hostname that forms the FQDN. | `string` | n/a | yes |
| memory | The amount of RAM in MB. | `string` | `"2048"` | no |
| network\_bridge\_name | The name of the Network Bridge. | `string` | `"br0"` | no |
| network\_gateway\_ip | A string of the network's gateway IP. | `string` | n/a | yes |
| network\_ip\_address | The IP Address to use for the network config. | `string` | n/a | yes |
| network\_nameserver\_ips | A comma seperated string of nameserver IPs. | `string` | `"127.0.0.1, 127.0.0.2"` | no |
| network\_subnet | The subnet mask used by the network. | `string` | `"24"` | no |
| vcpus | The number of Virtual CPUs. | `number` | `1` | no |

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
