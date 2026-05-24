let flatcar_init_node_type
    : Type
    = { cidr : Natural
      , disk_capacity_gb : Natural
      , dns : Text
      , gateway : Text
      , interface : Text
      , ip_address : Text
      , keepalived_priority : Natural
      , mac_address : Text
      , memory : Natural
      , name : Text
      , vcpu : Natural
      }

let flatcar_join_node_type
    : Type
    = { cidr : Natural
      , disk_capacity_gb : Natural
      , dns : Text
      , gateway : Text
      , interface : Text
      , ip_address : Text
      , keepalived_priority : Natural
      , mac_address : Text
      , memory : Natural
      , name : Text
      , vcpu : Natural
      }

let flatcar_worker_node_type
    : Type
    = { name : Text
      , interface : Text
      , mac_address : Text
      , memory : Natural
      , vcpu : Natural
      }

let flatcar_matchbox_node_type
    : Type
    = { name : Text
      , disk_capacity_gb : Natural
      , memory : Natural
      , vcpu : Natural
      }

let flatcar_etcd_type
    : Type
    = < init : flatcar_init_node_type | join : flatcar_join_node_type >

in  { flatcar_init_node_type
    , flatcar_join_node_type
    , flatcar_worker_node_type
    , flatcar_matchbox_node_type
    , flatcar_etcd_type
    }
