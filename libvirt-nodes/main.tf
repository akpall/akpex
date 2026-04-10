module "flatcar-network" {
  source = "./flatcar-network"

  flatcar_network_ip_address           = var.flatcar_network_ip_address
  flatcar_network_ip_dhcp_ranges_end   = var.flatcar_network_ip_dhcp_ranges_end
  flatcar_network_ip_dhcp_ranges_start = var.flatcar_network_ip_dhcp_ranges_start
  flatcar_network_ip_netmask           = var.flatcar_network_ip_netmask
  flatcar_network_mode                 = var.flatcar_network_mode
  flatcar_network_name                 = var.flatcar_network_name
  flatcar_network_nat_ports_end        = var.flatcar_network_nat_ports_end
  flatcar_network_nat_ports_start      = var.flatcar_network_nat_ports_start
}

module "flatcar-etcd-init_node" {
  for_each = local.flatcar_etcd_init_nodes

  source     = "./flatcar-etcd-node"
  depends_on = [module.flatcar-network]

  vm_name             = each.key
  disk_capacity_bytes = each.value.disk_capacity_bytes
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-etcd-join_node" {
  for_each = local.flatcar_etcd_join_nodes

  source     = "./flatcar-etcd-node"
  depends_on = [module.flatcar-network]

  vm_name             = each.key
  disk_capacity_bytes = each.value.disk_capacity_bytes
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-worker-nodes" {
  for_each = local.flatcar_worker_nodes

  source     = "./flatcar-worker-node"
  depends_on = [module.flatcar-network]

  vm_name     = each.key
  mac_address = each.value.mac_address
  memory      = each.value.memory
  vcpu        = each.value.vcpu
}

module "flatcar-matchbox-node" {
  for_each = local.flatcar_matchbox_nodes

  source     = "./flatcar-matchbox-node"
  depends_on = [module.flatcar-network]

  vm_name              = each.key
  matchbox_ca_crt      = local.matchbox_ca_crt
  disk_capacity_bytes  = each.value.disk_capacity_bytes
  flatcar_channel      = var.flatcar_channel
  flatcar_version      = var.flatcar_version
  memory               = each.value.memory
  matchbox_server_crt  = local.matchbox_server_crt
  matchbox_server_key  = local.matchbox_server_key
  matchbox_ip          = var.matchbox_ip
  matchbox_cidr        = var.matchbox_cidr
  matchbox_gateway     = var.matchbox_gateway
  matchbox_dns_servers = var.matchbox_dns_servers
  vcpu                 = each.value.vcpu
}
