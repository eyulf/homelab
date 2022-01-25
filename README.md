# Homelab Infrastructure

## Overview

This repository contains everything used to set-up the infrastructure for my homelab using as much IaC as possible as part of my [homelab refresh](https://alexgardner.id.au/blog/home-lab-refresh/). For more details, see the README of the following directories.

- [ansible](ansible) roles for server configuration.
- [pki](pki) script to pre-generate PKI certificates for Kubernetes.
- [terraform](terraform) configuration for provisioning VMs.

## SOPS

[SOPS](https://github.com/mozilla/sops) and [age](https://github.com/FiloSottile/age) are used to encrypt secrets that are stored in git.

```bash
touch ansible/group_vars/all.yml
sops -e ansible/group_vars/all.yml > ansible/group_vars/all.enc.yml
git status -s | grep group_vars
````

## Hardware
This is documented in more detail on my [website](https://alexgardner.id.au/homelab/), but consists of the following.

| Device           | Count | Storage                  | Purpose         |
|------------------|-------|--------------------------|-----------------|
| Custom NAS       | 1     | 15TB RAID-Z3 + 120GB SSD | Main storage    |
| ThinkCentre M900 | 3     | 1TB SSD                  | KVM Hypervisors |

## Thanks

The inspiration to make this public has come from the people that have shared their homelab/kubernetes configurations at [awesome-home-kubernetes](https://github.com/k8s-at-home/awesome-home-kubernetes).
