locals {
  flatcar-etcd-nodes   = { for i in range(0, 3) : i => "flatcar-node${i}" }
  flatcar-worker-nodes = { for i in range(3, 8) : i => "flatcar-node${i}" }
}

module "flatcar-matchbox-node" {
  source  = "./modules/flatcar-matchbox-node"
  vm_name = "flatcar-matchbox-node"

  server-certificate = file("${path.root}/../scripts/tls/server.crt")
  server-private-key = file("${path.root}/../scripts/tls/server.key")
  ca-certificate     = file("${path.root}/../scripts/tls/ca.crt")
}

module "flatcar-worker-nodes" {
  source   = "./modules/flatcar-worker-node"
  for_each = local.flatcar-worker-nodes
  vm_name  = each.value

  mac_address = format("52:54:00:00:00:%02x", each.key)
}
