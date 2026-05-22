locals {
  nodes     = yamldecode(file(var.NODES_PATH))
  variables = yamldecode(file(var.VARIABLES_PATH))

  flatcar_etcd_init_nodes = {
    "flatcar-node0" = {
      disk_capacity_bytes = 20 * 1024 * 1024 * 1024
      mac_address         = "52:54:00:00:00:00"
      memory              = 2048
      vcpu                = 2
    }
  }

  flatcar_etcd_join_nodes = {
    "flatcar-node1" = {
      disk_capacity_bytes = 20 * 1024 * 1024 * 1024
      mac_address         = "52:54:00:00:00:01"
      memory              = 2048
      vcpu                = 2
    }
    "flatcar-node2" = {
      disk_capacity_bytes = 20 * 1024 * 1024 * 1024
      mac_address         = "52:54:00:00:00:02"
      memory              = 2048
      vcpu                = 2
    }
  }
}
