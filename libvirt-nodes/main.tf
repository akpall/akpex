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
}

module "flatcar-etcd-init_node" {
  for_each = {
    for init-node in local.nodes.flatcar_etcd_init_node :
    init-node => local.nodes[init-node]
  }

  source     = "./flatcar-etcd-node"
  depends_on = [module.flatcar-network]

  vm_name             = each.value.name
  disk_capacity_gb = each.value.disk_capacity_gb
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-etcd-join_node" {
  for_each = {
    for join-node in local.nodes.flatcar_etcd_join_nodes :
    join-node => local.nodes[join-node]
  }

  source     = "./flatcar-etcd-node"
  depends_on = [module.flatcar-network]

  vm_name             = each.value.name
  disk_capacity_gb = each.value.disk_capacity_gb
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-worker-nodes" {
  for_each = {
    for worker-node in local.nodes.flatcar_worker_nodes :
    worker-node => local.nodes[worker-node]
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

  vm_name              = local.nodes.flatcar-matchbox-node.name
  matchbox_ca_crt      = file(local.variables.matchbox_ca_crt_path)
  disk_capacity_gb     = local.nodes.flatcar-matchbox-node.disk_capacity_gb
  flatcar_channel      = local.variables.flatcar_channel
  flatcar_version      = local.variables.flatcar_version
  memory               = local.nodes.flatcar-matchbox-node.memory
  matchbox_server_crt  = file(local.variables.matchbox_server_crt_path)
  matchbox_server_key  = file(local.variables.matchbox_server_key_path)
  matchbox_ip          = local.variables.matchbox_ip
  matchbox_cidr        = local.variables.matchbox_cidr
  matchbox_gateway     = local.variables.matchbox_gateway
  matchbox_dns_servers = local.variables.matchbox_dns_servers
  vcpu                 = local.nodes.flatcar-matchbox-node.vcpu
}
