terraform {
  required_version = ">= 1.0"
  required_providers {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.14.0"
    }
    matchbox = {
      source  = "poseidon/matchbox"
      version = "~> 0.5.4"
    }
  }
}

provider "matchbox" {
  endpoint    = var.matchbox_rpc_endpoint
  client_cert = local.matchbox_client_crt
  client_key  = local.matchbox_client_key
  ca          = local.matchbox_ca_crt
}
