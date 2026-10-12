include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/generate-root-ca"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
}

inputs = {
  allowed_uses = [
    "digital_signature",
    "cert_signing"
  ]
  common_name           = "matchbox-ca"
  validity_period_hours = 87600
}
