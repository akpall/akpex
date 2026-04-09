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
  source   = "./flatcar-etcd-node"
  for_each = local.flatcar_etcd_init_nodes
  vm_name  = each.key

  mac_address = each.value.mac
  disk_capacity_bytes = each.value.disk_capacity_bytes
  vcpu = each.value.vcpu
  memory = 2048
}

module "flatcar-etcd-join_node" {
  source   = "./flatcar-etcd-node"
  for_each = local.flatcar_etcd_join_nodes
  vm_name  = each.key

  mac_address = each.value.mac
  disk_capacity_bytes = each.value.disk_capacity_bytes
  vcpu = each.value.vcpu
  memory = 2048
}

module "flatcar-worker-nodes" {
  for_each = local.flatcar_worker_nodes

  source  = "./flatcar-worker-node"
  vm_name = each.key

  mac_address = each.value.mac_address
  memory      = each.value.memory
  vcpu        = each.value.vcpu
}
