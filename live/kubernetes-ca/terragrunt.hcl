include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/kubernetes-ca"
}

locals {
  vars             = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
  kubernetes_ha_ip = local.vars.locals.kubernetes_ha_ip
}

inputs = {
  kubernetes_ha_ip = local.kubernetes_ha_ip
}
