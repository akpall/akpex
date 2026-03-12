terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.4"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.14.0"
    }
  }
}
