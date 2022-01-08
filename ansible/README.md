## Ansible Playbooks

### General Assumptions

It is assumed that all physical servers have already had your SSH key added to the ansible user, either through post installation scripts or manually using `ssh-copy-id`.

### KVM Hypervisors
Configure KVM Hypervisors using QEMU and LibVirt.

**Assumptions**
- Debian 10.x installed with only the following software selected:
  - SSH server
  - standard system utilities

```bash
ansible-playbook kvm-hypervisors.yml -i production
```
