let T = ./types.dhall

let flatcar-node0
    : T.flatcar_init_node_type
    = { cidr = 24
      , disk_capacity_gb = 20
      , dns = "192.168.100.1"
      , gateway = "192.168.100.1"
      , interface = "eth0"
      , ip_address = "192.168.100.2"
      , keepalived_priority = 100
      , mac_address = "52:54:00:00:00:00"
      , memory = 2048
      , name = "flatcar-node0"
      , vcpu = 2
      }

let flatcar-node1
    : T.flatcar_join_node_type
    = { cidr = 24
      , disk_capacity_gb = 20
      , dns = "192.168.100.1"
      , gateway = "192.168.100.1"
      , interface = "eth0"
      , ip_address = "192.168.100.3"
      , keepalived_priority = 100
      , mac_address = "52:54:00:00:00:01"
      , memory = 2048
      , name = "flatcar-node1"
      , vcpu = 2
      }

let flatcar-node2
    : T.flatcar_join_node_type
    = { cidr = 24
      , disk_capacity_gb = 20
      , dns = "192.168.100.1"
      , gateway = "192.168.100.1"
      , interface = "eth0"
      , ip_address = "192.168.100.4"
      , keepalived_priority = 100
      , mac_address = "52:54:00:00:00:02"
      , memory = 2048
      , name = "flatcar-node2"
      , vcpu = 2
      }

let flatcar-node3
    : T.flatcar_worker_node_type
    = { name = "flatcar-node3"
      , interface = "eth0"
      , mac_address = "52:54:00:00:00:03"
      , memory = 8192
      , vcpu = 2
      }

let flatcar-node4
    : T.flatcar_worker_node_type
    = { name = "flatcar-node4"
      , interface = "eth0"
      , mac_address = "52:54:00:00:00:04"
      , memory = 8192
      , vcpu = 2
      }

let flatcar-node5
    : T.flatcar_worker_node_type
    = { name = "flatcar-node5"
      , interface = "eth0"
      , mac_address = "52:54:00:00:00:05"
      , memory = 8192
      , vcpu = 2
      }

let flatcar-node6
    : T.flatcar_worker_node_type
    = { name = "flatcar-node6"
      , interface = "eth0"
      , mac_address = "52:54:00:00:00:06"
      , memory = 8192
      , vcpu = 2
      }

let flatcar-node7
    : T.flatcar_worker_node_type
    = { name = "flatcar-node7"
      , interface = "eth0"
      , mac_address = "52:54:00:00:00:07"
      , memory = 8192
      , vcpu = 2
      }

let flatcar-matchbox-node
    : T.flatcar_matchbox_node_type
    = { name = "flatcar-matchbox-node"
      , disk_capacity_gb = 20
      , memory = 2048
      , vcpu = 2
      }

let flatcar_etcd_init_node = flatcar-node0

let flatcar_etcd_join_nodes
    : List T.flatcar_join_node_type
    = [ flatcar-node1, flatcar-node2 ]

let flatcar_worker_nodes
    : List T.flatcar_worker_node_type
    = [ flatcar-node3
      , flatcar-node4
      , flatcar-node5
      , flatcar-node6
      , flatcar-node7
      ]

let flatcar_etcd_nodes
    : List T.flatcar_etcd_type
    = [ T.flatcar_etcd_type.init flatcar-node0
      , T.flatcar_etcd_type.join flatcar-node1
      , T.flatcar_etcd_type.join flatcar-node2
      ]

in  { flatcar-node0
    , flatcar-node1
    , flatcar-node2
    , flatcar-node3
    , flatcar-node4
    , flatcar-node5
    , flatcar-node6
    , flatcar-node7
    , flatcar-matchbox-node
    , flatcar_etcd_init_node
    , flatcar_etcd_join_nodes
    , flatcar_worker_nodes
    , flatcar_etcd_nodes
    }
