terraform {
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.14.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.9.7"
    }
  }
}
