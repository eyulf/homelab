# Alex's Homelab

My Homelab utilizes [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) and [GitOps methodologies](https://www.weave.works/blog/what-is-gitops-really) to automate provisioning, operating, and updating self-hosted services. I have also been documenting the progress of this on my blog as part of my [homelab refresh](https://alexgardner.id.au/blog/home-lab-refresh/).

## Overview

This section provides a high level overview of my homelab. For more details, see the README of the following directories.

- [ansible](ansible) roles for server configuration.
- [kubernetes](kubernetes) configuration deployed using Flux2.
- [pki](pki) script to pre-generate PKI certificates for Kubernetes.
- [terraform](terraform) configuration for provisioning VMs.

[SOPS](https://github.com/mozilla/sops) and [age](https://github.com/FiloSottile/age) are used to encrypt secrets that are stored in git.

### Hardware

This is also documented on my [website](https://alexgardner.id.au/homelab/), but consists of the following.

- 1x Mikrotik CRS109-8G-1S-2HnD-IN Router

- 1x CyberPower UPS PR750ELCD

- 3x ThinkCentre M900 Tiny (USFF)
  - Intel Core i5-6500T 2.50GHz CPU
  - 32GB DDR4 RAM
  - 1TB SSD

- 1x Custom NAS
  - U-NAS NSC-810A Server Chassis
  - Seasonic SS-350M1U Mini 1U PSU
  - Supermicro X10SLM-F Motherboard
  - Intel Core i3-4170 3.7Ghz CPU
  - 16GB ECC DDR3 RAM
  - 6x 3TB WD Red HDD (RAID-Z3)
  - 120GB SSD (OS)

### Tech stack

My Homelab uses the following software, this list is non-exhaustive.

<table>
  <tr>
    <th>Logo</th>
    <th>Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/131524?s=200&v=4"></td>
    <td><a href="https://github.com/mozilla/sops">sops</a></td>
    <td>Encrypted secrets in Git</td>
  </tr>
  <tr>
    <td><img width="32" src="https://simpleicons.org/icons/debian.svg"></td>
    <td><a href="https://www.debian.org">Debian</a></td>
    <td>Base OS for all servers</td>
  </tr>
  <tr>
    <td></td>
    <td><a href="https://www.linux-kvm.org">KVM</a></td>
    <td>Virtual Machine Hypervisor</td>
  </tr>
  <tr>
    <td><img width="32" src="https://simpleicons.org/icons/terraform.svg"></td>
    <td><a href="https://www.terraform.io">Terraform</a></td>
    <td>VM provisioning</td>
  </tr>
  <tr>
    <td><img width="32" src="https://simpleicons.org/icons/ansible.svg"></td>
    <td><a href="https://www.ansible.com">Ansible</a></td>
    <td>Server configuration</td>
  </tr>
  <tr>
    <td><img width="32" src="https://simpleicons.org/icons/docker.svg"></td>
    <td><a href="https://www.docker.com">Docker</a></td>
    <td>Container runtime</td>
  </tr>
  <tr>
    <td><img width="32" src="https://simpleicons.org/icons/kubernetes.svg"></td>
    <td><a href="https://kubernetes.io">Kubernetes</a></td>
    <td>Container orchestration</td>
  </tr>
  <tr>
    <td><img width="32" src="https://simpleicons.org/icons/helm.svg"></td>
    <td><a href="https://helm.sh">Helm</a></td>
    <td>Package manager for Kubernetes</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/52158677?s=200&v=4"></td>
    <td><a href="https://fluxcd.io">Flux2</a></td>
    <td>GitOps solution for Kubernetes</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/34656521?s=200&v=4"></td>
    <td><a href="https://github.com/bitnami-labs/sealed-secrets">Sealed Secrets</a></td>
    <td>Encrypted Kubernetes secrets that are safe to store in git</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/60239468?s=200&v=4"></td>
    <td><a href="https://metallb.universe.tf">MetalLB</a></td>
    <td>Load Balancer for bare metal Kubernetes clusters</td>
  </tr>
</table>

## Acknowledgements

The inspiration to make this public has come from the people that have shared their homelab/kubernetes configurations at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes).
