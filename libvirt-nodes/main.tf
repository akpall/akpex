module "flatcar-network" {
  source = "./flatcar-network"

  flatcar_network_ip_address           = local.variables.flatcar_network_ip_address
  flatcar_network_ip_dhcp_ranges_end   = local.variables.flatcar_network_ip_dhcp_ranges_end
  flatcar_network_ip_dhcp_ranges_start = local.variables.flatcar_network_ip_dhcp_ranges_start
  flatcar_network_ip_netmask           = local.variables.flatcar_network_ip_netmask
  flatcar_network_mode                 = local.variables.flatcar_network_mode
  flatcar_network_name                 = local.variables.flatcar_network_name
  flatcar_network_nat_ports_end        = local.variables.flatcar_network_nat_ports_end
  flatcar_network_nat_ports_start      = local.variables.flatcar_network_nat_ports_start
  nodes                                = local.nodes
}

module "flatcar-etcd-init_node" {
  source     = "./flatcar-etcd-node"
  depends_on = [module.flatcar-network]

  vm_name          = local.nodes.flatcar-node0.name
  disk_capacity_gb = local.nodes.flatcar-node0.disk_capacity_gb
  mac_address      = local.nodes.flatcar-node0.mac_address
  memory           = local.nodes.flatcar-node0.memory
  vcpu             = local.nodes.flatcar-node0.vcpu
}

module "flatcar-etcd-join_node" {
  for_each = {
    for node in local.nodes.flatcar_etcd_join_nodes :
    node.name => node
  }

  source     = "./flatcar-etcd-node"
  depends_on = [module.flatcar-network]

  vm_name          = each.value.name
  disk_capacity_gb = each.value.disk_capacity_gb
  mac_address      = each.value.mac_address
  memory           = each.value.memory
  vcpu             = each.value.vcpu
}

module "flatcar-worker-nodes" {
  for_each = {
    for node in local.nodes.flatcar_worker_nodes :
    node.name => node
  }

  source     = "./flatcar-worker-node"
  depends_on = [module.flatcar-network]

  vm_name     = each.value.name
  mac_address = each.value.mac_address
  memory      = each.value.memory
  vcpu        = each.value.vcpu
}

module "flatcar-matchbox-node" {
  source     = "./flatcar-matchbox-node"
  depends_on = [module.flatcar-network]

  disk_capacity_gb     = local.nodes.flatcar-matchbox-node.disk_capacity_gb
  flatcar_channel      = local.variables.flatcar_channel
  flatcar_version      = local.variables.flatcar_version
  mac_address          = local.nodes.flatcar-matchbox-node.mac_address
  matchbox_ca_crt      = file(local.variables.matchbox_ca_crt_path)
  matchbox_cidr        = local.nodes.flatcar-matchbox-node.cidr
  matchbox_dns_servers = local.nodes.flatcar-matchbox-node.dns_server
  matchbox_gateway     = local.nodes.flatcar-matchbox-node.gateway
  matchbox_ip          = local.nodes.flatcar-matchbox-node.ip_address
  matchbox_server_crt  = file(local.variables.matchbox_server_crt_path)
  matchbox_server_key  = file(local.variables.matchbox_server_key_path)
  memory               = local.nodes.flatcar-matchbox-node.memory
  vcpu                 = local.nodes.flatcar-matchbox-node.vcpu
  vm_name              = local.nodes.flatcar-matchbox-node.name
}
