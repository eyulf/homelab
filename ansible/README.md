# Ansible Playbooks

## General Assumptions

- It is assumed that all physical servers have already had your SSH key added to the ansible user, either through post installation scripts or manually using `ssh-copy-id`.

## KVM Hypervisors
Configure KVM Hypervisors using QEMU and LibVirt.

**Assumptions**
- Debian 10.x installed with only the following software selected:
  - SSH server
  - standard system utilities

```bash
ansible-playbook kvm-hypervisors.yml -i production
```

## DNS Servers
Configure PowerDNS backed by a MariaDB Galera cluster.

**Assumptions**
- Debian 10.x installed with only the following software selected:
  - SSH server
  - standard system utilities

```bash
ansible-playbook dns-servers -i production
```

## Kubernetes
Configure and create a Kubernetes cluster, including both controller and worker nodes.

**Assumptions**
- Debian 10.x installed with only the following software selected:
  - SSH server
  - standard system utilities

```bash
ansible-playbook k8s-all.yml -i production
ansible-playbook k8s-controllers.yml -i production
ansible-playbook k8s-workers.yml -i production
```
