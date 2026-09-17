include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/matchbox-ca"
}

locals {
  vars                         = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
  matchbox-server-ip_addresses = local.vars.locals.matchbox-server-ip_addresses
}

inputs = {
  matchbox-server-ip_addresses = local.matchbox-server-ip_addresses
}
