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

  vm_name             = each.key
  ca_certificate      = local.matchbox_ca_crt
  disk_capacity_bytes = each.value.disk_capacity_bytes
  flatcar_channel     = var.flatcar_channel
  flatcar_version     = var.flatcar_version
  memory              = each.value.memory
  server_certificate  = local.matchbox_server_crt
  server_private_key  = local.matchbox_server_key
  vcpu                = each.value.vcpu
}

module "matchbox" {
  source     = "./matchbox"
  depends_on = [module.flatcar-matchbox-node]

  ssh_authorized_key     = var.ssh_authorized_key
  matchbox_http_endpoint = local.matchbox_http_endpoint
  matchbox_rpc_endpoint  = local.matchbox_rpc_endpoint

  matchbox_client_key = local.matchbox_client_crt
  matchbox_ip         = var.matchbox_ip
  matchbox_ca_crt     = local.matchbox_ca_crt
  matchbox_client_crt = local.matchbox_client_crt

  flatcar_version = var.flatcar_version

  kubernetes_ha_ip = var.kubernetes_ha_ip

  keepalived_version = var.keepalived_version

  cilium_version            = var.cilium_version
  kubernetes_config_version = var.kubernetes_config_version
  kubernetes_version        = var.kubernetes_version
}