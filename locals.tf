locals {
  flatcar_etcd_init_nodes = {
    "flatcar-node0" = {
      mac                 = "52:54:00:00:00:00"
      interface           = "eth0"
      ip                  = "192.168.100.2"
      cidr                = 24
      dns                 = "192.168.100.1"
      gateway             = "192.168.100.1"
      keepalived_priority = 100
      disk_capacity_bytes = 20 * 1024 * 1024 * 1024
      vcpu = 2
    }
  }

  flatcar_etcd_join_nodes = {
    "flatcar-node1" = {
      mac                 = "52:54:00:00:00:01"
      interface           = "eth0"
      ip                  = "192.168.100.3"
      cidr                = 24
      dns                 = "192.168.100.1"
      gateway             = "192.168.100.1"
      keepalived_priority = 90
      disk_capacity_bytes = 20 * 1024 * 1024 * 1024
      vcpu = 2
    }
    "flatcar-node2" = {
      mac                 = "52:54:00:00:00:02"
      interface           = "eth0"
      ip                  = "192.168.100.4"
      cidr                = 24
      dns                 = "192.168.100.1"
      gateway             = "192.168.100.1"
      keepalived_priority = 80
      disk_capacity_bytes = 20 * 1024 * 1024 * 1024
      vcpu = 2
    }
  }

  flatcar_worker_nodes = {
    "flatcar-node3" = {
      mac_address = "52:54:00:00:00:03"
      memory      = 2048
      vcpu        = 2
    }
  }
}
