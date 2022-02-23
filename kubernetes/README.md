# Kubernetes

## Overview

This contains the configuration used by [ArgoCD](https://argoproj.github.io/cd/) to make changes to my Kubernetes cluster. ArgoCD uses an [`App of Apps`](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/) pattern to deploy the configuration.

This assumes that the Kubernetes cluster has first been deployed using Ansible and that ArgoCD has been bootstrapped.

## Namespaces

The following NameSpaces are used for ArgoCD itself, other core infrastructure, general infrastructure, and apps.

### ArgoCD

- **[argocd-system](core/argocd-system)**

### Core Infrastructure

- 

### General Infrastructure

- 

### Apps

- 
