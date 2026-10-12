include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/libvirt-flatcar-etcd-node"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
}

inputs = {
  flatcar-etcd-nodes = {
    for n in local.vars.locals.flatcar-etcd-nodes : n.vm_name => n
  }
}
