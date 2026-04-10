terraform {
  required_version = ">= 1.0"
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "0.14.0"
    }
    matchbox = {
      source  = "poseidon/matchbox"
      version = "0.5.4"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.9.7"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }
}


provider "matchbox" {
  endpoint    = local.matchbox_rpc_endpoint
  client_cert = tls_locally_signed_cert.matchbox_client_crt.cert_pem
  client_key  = tls_private_key.matchbox_client_key.private_key_pem
  ca          = tls_self_signed_cert.matchbox_ca_crt.cert_pem
}
