locals {
  nodes = { for i in range(0, 3) : "flatcar-node${i}" => "" }
}

module "flatcar-network" {
  source = "./modules/flatcar-network"

  network_name               = "flatcar_network"
  network_ip_dhcp_ranges_end = "192.168.100.253"
}

module "flatcar-matchbox" {
  source = "./modules/flatcar-matchbox"
}


module "flatcar-nodes" {
  source   = "./modules/flatcar-node"
  for_each = local.nodes

  vm_name = each.key
}
