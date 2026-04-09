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

  source  = "./flatcar-etcd-node"
  vm_name = each.key

  disk_capacity_bytes = each.value.disk_capacity_bytes
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-etcd-join_node" {
  for_each = local.flatcar_etcd_join_nodes

  source  = "./flatcar-etcd-node"
  vm_name = each.key

  disk_capacity_bytes = each.value.disk_capacity_bytes
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-worker-nodes" {
  for_each = local.flatcar_worker_nodes

  source  = "./flatcar-worker-node"
  vm_name = each.key

  mac_address = each.value.mac_address
  memory      = each.value.memory
  vcpu        = each.value.vcpu
}

module "flatcar-matchbox-node" {
  for_each = local.flatcar_matchbox_nodes

  source  = "./flatcar-matchbox-node"
  vm_name = each.key

  ca_certificate      = file("${path.root}/scripts/tls/ca.crt")
  disk_capacity_bytes = each.value.disk_capacity_bytes
  flatcar_channel     = var.flatcar_channel
  flatcar_release     = var.flatcar_release
  memory              = each.value.memory
  server_certificate  = file("${path.root}/scripts/tls/server.crt")
  server_private_key  = file("${path.root}/scripts/tls/server.key")
  vcpu                = each.value.vcpu
}
