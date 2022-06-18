# Ansible Playbooks

## General Assumptions

- It is assumed that all physical servers have already had your SSH key added to the ansible user, either through post installation scripts or manually using `ssh-copy-id`.

### Editing Variables

Most variables are saved in plain-text, however, some are encrypted using a combination of [SOPS](https://github.com/mozilla/sops) and [age](https://github.com/FiloSottile/age). These can be edited in-place using the `sops` cli.

```bash
sops -i group_vars/all.sops.yml
```

The community provided [SOPS Ansible collection](https://docs.ansible.com/ansible/latest/collections/community/sops/docsite/guide.html) is used to load the encrypted variables without manual intervention required.

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
