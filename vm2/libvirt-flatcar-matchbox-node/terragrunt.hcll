include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

dependency "matchbox-ca" {
  config_path = "../matchbox-ca/"

  mock_outputs = {
    matchbox-ca-pub     = "mock-matchbox-ca-pub"
    matchbox-server-pub = "mock-matchbox-server-pub"
    matchbox-server-key = "mock-matchbox-server-key"
  }
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/libvirt-flatcar-matchbox-node"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
}

inputs = {
  disk_capacity_gb              = 20
  flatcar_channel               = local.vars.locals.flatcar_channel
  flatcar_production_qemu_image = local.vars.locals.flatcar_production_qemu_image
  flatcar_version               = local.vars.locals.flatcar_version
  mac_address                   = "52:54:00:00:00:08"
  matchbox_ca_crt               = dependency.matchbox-ca.outputs.matchbox-ca-pub
  matchbox_cidr                 = 24
  matchbox_dns_servers          = local.vars.locals.matchbox_dns_servers
  matchbox_gateway              = local.vars.locals.matchbox_gateway
  matchbox_ip                   = local.vars.locals.matchbox_ip
  matchbox_server_crt           = dependency.matchbox-ca.outputs.matchbox-server-pub
  matchbox_server_key           = dependency.matchbox-ca.outputs.matchbox-server-key
  memory                        = 2048
  ssh_authorized_keys           = local.vars.locals.ssh_authorized_keys
  vcpu                          = 2
  vm_name                       = "flatcar-matchbox-node"
  flatcar_urls = [
    local.vars.locals.flatcar_production_image_bin,
    local.vars.locals.flatcar_production_pxe_image_cpio,
    local.vars.locals.flatcar_production_pxe_vmlinuz
  ]
}
