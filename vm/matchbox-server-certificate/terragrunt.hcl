include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "matchbox-ca" {
  config_path = "../matchbox-ca/"
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/generate-certificate"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
}

inputs = {
  allowed_uses = [
    "digital_signature",
    "content_commitment",
    "key_encipherment",
    "client_auth"
  ]
  common_name = "matchbox-server-certificate"
  validity_period_hours = 8760
  ca_private_key_pem = dependency.matchbox-ca.outputs.ca-key
  ca_cert_pem = dependency.matchbox-ca.outputs.ca-crt
}
