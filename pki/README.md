# Kubernetes PKI Generation

This generates PKI certificates using [cfssl](https://github.com/cloudflare/cfssl) for a Kubernetes cluster. This allows PKI certificates and keys to be easily distributed to the servers using Ansible.

The PKI certificates are generated and named in line with [Kubernetes best practices for PKI certificates](https://kubernetes.io/docs/setup/best-practices/certificates/).

## Requirements

- You need to have [cfssl](https://github.com/cloudflare/cfssl) installed and the related binaries located within your $PATH.
- This script expects the following to be set in the Ansible inventory:
  - The `ansible_host` host variable to be configured as an IP address
  - The `domain` group variable to be configured
  - The `corosync_cluster_name` group variable to be configured
  - The `corosync_cluster_ip` group variable to be configured

## Usage

This script will do the following:
- Generate PKI files for Kubernetes, pulling data from Ansible where required
- Copy PKI files to the Ansible Kubernetes role directory for distribution
- Encrypt the copied PKI files using sops into new encrypted files

Create all certificates
```bash
./pki-gen all
```

Remove all certificates (will not remove from Ansible directory)
```bash
./pki-gen clean
```
