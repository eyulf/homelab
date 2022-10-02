terraform {
  required_version = ">= 1.1"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.6.14"
    }
    sops = {
      source  = "carlpett/sops"
      version = "0.7.1"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}
