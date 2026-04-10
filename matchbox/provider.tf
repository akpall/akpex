// Configure the matchbox provider
provider "matchbox" {
  endpoint    = var.matchbox_rpc_endpoint
  client_cert = tls_locally_signed_cert.matchbox_client_crt
  client_key  = tls_private_key.matchbox_client_key
  ca          = tls_self_signed_cert.matchbox_ca_crt
}

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
  }
}
