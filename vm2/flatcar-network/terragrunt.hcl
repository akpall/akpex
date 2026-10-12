include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/libvirt-network"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
}

inputs = {
  name                 = local.vars.locals.flatcar_network_name
  ip_address           = local.vars.locals.flatcar_network_ip_address
  ip_dhcp_ranges_end   = local.vars.locals.flatcar_network_ip_dhcp_ranges_end
  ip_dhcp_ranges_start = local.vars.locals.flatcar_network_ip_dhcp_ranges_start
  ip_netmask           = local.vars.locals.flatcar_network_ip_netmask
}
