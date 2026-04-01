locals {
  flatcar-etcd-nodes   = { for i in range(1, 3) : "flatcar-node${i}" => "" }
  flatcar-worker-nodes = { for i in range(3, 8) : "flatcar-node${i}" => "" }
}

module "flatcar-network" {
  source                     = "./modules/flatcar-network"
  network_name               = "flatcar_network"
  network_ip_dhcp_ranges_end = "192.168.100.253"
}

module "flatcar-matchbox" {
  source  = "./modules/flatcar-matchbox"
  vm_name = "flatcar-node0"
}

module "flatcar-etcd-nodes" {
  source   = "./modules/flatcar-etcd-node"
  for_each = local.flatcar-etcd-nodes
  vm_name  = each.key
}

module "flatcar-worker-nodes" {
  source   = "./modules/flatcar-worker-node"
  for_each = local.flatcar-worker-nodes
  vm_name  = each.key
}
