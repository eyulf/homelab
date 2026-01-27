terraform {
  required_version = ">= 1.3"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.2"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.0"
    }
  }
}
