# Terraform Configuration

## General Assumptions

- Regular users of Terraform will note that remote states are not being used. While this goes against best practice, this is intentional for the following reasons.

  1. As a personal homelab, this environment is primarily maintained by a single user.
  2. No cloud resources are being managed or configured by this repository.
  3. In the event a state file gets corrupted or goes missing, the state data can be re-imported into a new state file.

- The [`dmacvicar/libvirt`](https://github.com/dmacvicar/terraform-provider-libvirt) provider module is used to for KVM resources.
- The [`carlpett/sops`](https://github.com/carlpett/terraform-provider-sops) provider module is used to decrypt data encrypted by [SOPS](https://github.com/mozilla/sops) with [age](https://github.com/FiloSottile/age).

## Infrastructure

The [infrastructure](infrastructure) directory contains all infrastructure configuration separated into distinct parts with their own states. This reduces the blast radius from a potential misconfiguration taking out all infrastructure at once.

### Hypervisors

The configuration contained within the [infrastructure/hypervisors](infrastructure/hypervisors) state configures KVM on the KVM Hypervisors and provides output data that can be used by other states.

```bash
cd infrastructure/hypervisors
terraform init
terraform apply
```

### Core Services

The configuration contained within the [infrastructure/core_services](infrastructure/core_services) state creates KVM VMs for usage as DNS servers. These are deployed to the KVM hypervisors configured in [infrastructure/hypervisors](infrastructure/hypervisors).

```bash
cd infrastructure/core_services
terraform init
terraform apply
```

### Kubernetes

The configuration contained within the [infrastructure/kubernetes](infrastructure/kubernetes) state creates KVM VMs for usage as Kubernetes servers. These are deployed to the KVM hypervisors configured in [infrastructure/hypervisors](infrastructure/hypervisors).

```bash
cd infrastructure/kubernetes
terraform init
terraform apply
```
