locals {
  etcd-nodes = { for i in range(1, 3) : "flatcar-node${i}" => "" }
  nodes      = { for i in range(3, 8) : "flatcar-node${i}" => "" }
}

module "flatcar-network" {
  source = "./modules/flatcar-network"

  network_name               = "flatcar_network"
  network_ip_dhcp_ranges_end = "192.168.100.253"
}

module "flatcar-matchbox" {
  source = "./modules/flatcar-matchbox"

  vm_name = "flatcar-node0"
}

module "flatcar-etcd" {
  source   = "./modules/flatcar-node"
  for_each = local.etcd-nodes

  vm_name = each.key
}

module "flatcar-nodes" {
  source   = "./modules/flatcar-node"
  for_each = local.nodes

  vm_name = each.key
}
