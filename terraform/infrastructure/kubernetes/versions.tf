terraform {
  required_version = ">= 1.3"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
    sops = {
      source  = "carlpett/sops"
      version = "1.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
