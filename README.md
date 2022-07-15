# Alex's Homelab

[![GitHub Super-Linter](https://github.com/eyulf/homelab/workflows/Lint%20Code%20Base/badge.svg)](https://github.com/marketplace/actions/super-linter)

My Homelab utilizes [Infrastructure as Code](https://en.wikipedia.org/wiki/Infrastructure_as_code) and [GitOps methodologies](https://www.weave.works/blog/what-is-gitops-really) to automate provisioning, operating, and updating self-hosted services. I have also been documenting the progress of this on my blog as part of my [homelab refresh](https://alexgardner.id.au/blog/home-lab-refresh/).

Using my quick and dirty [rebuild](rebuild-k8s.sh) script, I can destroy and completely rebuild the Kubernetes Cluster with all defined apps deployed within approximately 30 minutes time.

## :book:&nbsp; Overview

The major components of the homelab configuration are split out into sub-directories. For more details, see the README of the following directories.

- [ansible](ansible) roles for server configuration.
- [kubernetes](kubernetes) configuration deployed using ArgoCD.
- [pki](pki) script to pre-generate PKI certificates for Kubernetes.
- [terraform](terraform) configuration for provisioning VMs.

[SOPS](https://github.com/mozilla/sops) and [age](https://github.com/FiloSottile/age) are currently used to encrypt secrets that are stored in git.

## :gear:&nbsp; Hardware

I've also documented this on my [website](https://alexgardner.id.au/homelab/), but the hardware used consists of the following.

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

## :robot:&nbsp; Automation

 - [Renovate](https://github.com/renovatebot/renovate) - Periodically scans the repo and opens pull requests when it detects updates for various "package managers", including Ansible, Kubernetes, Helm, and Terraform.

## :computer:&nbsp; Tasks

I'm using [Task](https://taskfile.dev/) to execute tasks defined in Taskfiles that have been created throughout the repo.

- [homelab](Taskfile.yaml)
- [homelab/ansible](ansible/Taskfile.yaml)

## :wrench:&nbsp; Tech stack

My homelab uses the following software, this list is non-exhaustive.

<table>
  <tr>
    <th>Logo</th>
    <th>Name</th>
    <th>Description</th>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/ansible/ansible-icon.svg"></td>
    <td><a href="https://www.ansible.com">Ansible</a></td>
    <td>Server configuration</td>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/debian/debian-icon.svg"></td>
    <td><a href="https://www.debian.org">Debian</a></td>
    <td>Base OS for all servers</td>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/docker/docker-tile.svg"></td>
    <td><a href="https://www.docker.com">Docker</a></td>
    <td>Container runtime</td>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/helmsh/helmsh-icon.svg"></td>
    <td><a href="https://helm.sh">Helm</a></td>
    <td>Package manager for Kubernetes</td>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/kubernetes/kubernetes-icon.svg"></td>
    <td><a href="https://kubernetes.io">Kubernetes</a></td>
    <td>Container orchestration</td>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/redhat/redhat-icon.svg"></td>
    <td><a href="https://www.linux-kvm.org">KVM</a></td>
    <td>Virtual Machine Hypervisor</td>
  </tr>
  <tr>
    <td><img width="32" src="https://libvirt.org/logos/logo-square-powered.svg"></td>
    <td><a href="https://libvirt.org/">libvirt</a></td>
    <td>Toolkit to manage KVM</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/60239468?s=200&v=4"></td>
    <td><a href="https://metallb.universe.tf">MetalLB</a></td>
    <td>Load Balancer for bare metal Kubernetes clusters</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/38656520?s=200&v=4"></td>
    <td><a href="https://github.com/renovatebot/renovate">Renovate</a></td>
    <td>Detects and corrects out-of-date dependencies</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/34656521?s=200&v=4"></td>
    <td><a href="https://github.com/bitnami-labs/sealed-secrets">Sealed Secrets</a></td>
    <td>Encrypted Kubernetes secrets that are safe to store in git</td>
  </tr>
  <tr>
    <td><img width="32" src="https://avatars.githubusercontent.com/u/131524?s=200&v=4"></td>
    <td><a href="https://github.com/mozilla/sops">sops</a></td>
    <td>Encrypted secrets in Git</td>
  </tr>
  <tr>
    <td><img width="32" src="https://www.vectorlogo.zone/logos/terraformio/terraformio-icon.svg"></td>
    <td><a href="https://www.terraform.io">Terraform</a></td>
    <td>VM provisioning</td>
  </tr>
</table>

## :handshake:&nbsp; Thanks

The inspiration to make this public has come from the people that have shared their homelab/kubernetes configurations at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes).
