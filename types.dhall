let flatcar_init_node_type
    : Type
    = { name : Text
      , cidr : Natural
      , disk_capacity_gb : Natural
      , dns : Text
      , gateway : Text
      , interface : Text
      , ip_address : Text
      , keepalived_priority : Natural
      , mac_address : Text
      , memory : Natural
      , vcpu : Natural
      }

let flatcar_join_node_type
    : Type
    = { name : Text
      , cidr : Natural
      , disk_capacity_gb : Natural
      , dns : Text
      , gateway : Text
      , interface : Text
      , ip_address : Text
      , keepalived_priority : Natural
      , mac_address : Text
      , memory : Natural
      , vcpu : Natural
      }

let flatcar_worker_node_type
    : Type
    = { name : Text
      , interface : Text
      , ip_address : Text
      , mac_address : Text
      , memory : Natural
      , vcpu : Natural
      }

let flatcar_matchbox_node_type
    : Type
    = { name : Text
      , cidr : Natural
      , disk_capacity_gb : Natural
      , dns_server : Text
      , gateway : Text
      , ip_address : Text
      , mac_address : Text
      , memory : Natural
      , vcpu : Natural
      }

let flatcar_etcd_type
    : Type
    = < init : flatcar_init_node_type | join : flatcar_join_node_type >

let flatcar_all_type
    : Type
    = < init : flatcar_init_node_type
      | join : flatcar_join_node_type
      | worker : flatcar_worker_node_type
      | matchbox : flatcar_matchbox_node_type
      >

in  { flatcar_init_node_type
    , flatcar_join_node_type
    , flatcar_worker_node_type
    , flatcar_matchbox_node_type
    , flatcar_etcd_type
    , flatcar_all_type
    }
