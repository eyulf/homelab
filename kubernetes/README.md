# Kubernetes

## Overview

This contains the configuration used by Flux2 to make changes to my Kubernetes cluster. Flux2 watches the [cluster](cluster) directory as the entry point for locating changes to be made.

This assumes that the cluster has first been deployed using Ansible and that Flux has been bootstrapped.

## Namespaces

The following NameSpaces are used for Flux itself, core infrastructure, and apps.

### Flux Clusters

- **[flux-system](clusters/homelab/flux-system)**

### Core Infrastructure

- **[kube-system](infrastructure/homelab/kube-system)**
  - [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets) - Encrypted secrets that are safe to store in git
- **[metallb-system](infrastructure/homelab/metallb-system)**
  - [metallb](https://metallb.universe.tf/) - Load Balancer for bare metal Kubernetes clusters

### Apps

- 
