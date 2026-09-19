include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

terraform {
  source = "${get_parent_terragrunt_dir()}/modules/libvirt-flatcar-network"
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("variables.hcl"))
}

inputs = {
  flatcar_network_ip_address           = local.vars.locals.flatcar_network_ip_address
  flatcar_network_ip_dhcp_ranges_end   = local.vars.locals.flatcar_network_ip_dhcp_ranges_end
  flatcar_network_ip_dhcp_ranges_start = local.vars.locals.flatcar_network_ip_dhcp_ranges_start
  flatcar_network_ip_netmask           = local.vars.locals.flatcar_network_ip_netmask
}
