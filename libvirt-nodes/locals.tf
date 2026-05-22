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

  flatcar_worker_nodes = {
    "flatcar-node3" = {
      mac_address = "52:54:00:00:00:03"
      memory      = 8192
      vcpu        = 2
    }
    "flatcar-node4" = {
      mac_address = "52:54:00:00:00:04"
      memory      = 8192
      vcpu        = 2
    }
    "flatcar-node5" = {
      mac_address = "52:54:00:00:00:05"
      memory      = 8192
      vcpu        = 2
    }
    "flatcar-node6" = {
      mac_address = "52:54:00:00:00:06"
      memory      = 8192
      vcpu        = 2
    }
    "flatcar-node7" = {
      mac_address = "52:54:00:00:00:07"
      memory      = 8192
      vcpu        = 2
    }
  }
}
