# Kubernetes

## Overview

This contains the configuration used by [ArgoCD](https://argoproj.github.io/cd/) to make changes to my Kubernetes cluster. ArgoCD uses an [`App of Apps`](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/) pattern to deploy the configuration.

This assumes that the Kubernetes cluster has first been deployed using Ansible and that ArgoCD has been bootstrapped.

## Namespaces

The following NameSpaces are used for ArgoCD itself, other core infrastructure, general infrastructure, and apps.

### Core Infrastructure

The [core](core) directory contains the minimum services that are required for the Kubernetes cluster to function and deploy other services and apps.

- **argocd-system**
  - [argocd](core/argocd) [\[website\]]((https://argoproj.github.io/cd/)) - GitOps continuous delivery tool for Kubernetes.
- **calico-system**
  - [calico](core/calico) [\[website\]](https://projectcalico.docs.tigera.io/about/about-calico) - Kubernetes cluster networking provider.
- **kube-system**
  - [sealed-secrets](core/sealed-secrets) [\[website\]](https://projectcalico.docs.tigera.io/about/about-calico) - Kubernetes cluster networking provider.

### General Infrastructure

The [infrastructure](infrastructure) directory contains the services that are used by the Kubernetes cluster to run the apps.

- **metallb-system**
  - [metallb](infrastructure/metallb) [\[website\]](https://metallb.universe.tf/) - Load Balancer for bare metal Kubernetes clusters.

### Apps

The [apps](apps) directory contains the apps that are deployed onto the Kubernetes cluster.

- **pihole**
  - [pihole](apps/pihole) [\[website\]](https://pi-hole.net/) - Network-wide Ad Blocking.

