let cilium_version
    : Text
    = "0.19.2"

let flatcar_channel
    : Text
    = "stable"

let flatcar_network_ip_address
    : Text
    = "192.168.100.1"

let flatcar_network_ip_dhcp_ranges_end
    : Text
    = "192.168.100.252"

let flatcar_network_ip_dhcp_ranges_start
    : Text
    = "192.168.100.5"

let flatcar_network_ip_netmask
    : Text
    = "255.255.255.0"

let flatcar_network_mode
    : Text
    = "nat"

let flatcar_network_name
    : Text
    = "flatcar_network"

let flatcar_network_nat_ports_end
    : Natural
    = 65535

let flatcar_network_nat_ports_start
    : Natural
    = 1024

let flatcar_version
    : Text
    = "4593.2.1"

let keepalived_version
    : Text
    = "2.3.4"

let kubernetes_config_version
    : Text
    = "1.36"

let kubernetes_ha_ip
    : Text
    = "192.168.100.253"

let kubernetes_version
    : Text
    = "1.36.1"

let matchbox_cidr
    : Natural
    = 24

let matchbox_dns_server
    : Text
    = "192.168.100.1"

let matchbox_gateway
    : Text
    = "192.168.100.1"

let matchbox_ip
    : Text
    = "192.168.100.254"

let matchbox_http_endpoint
    : Text
    = "http://${matchbox_ip}:8080"

let matchbox_rpc_endpoint
    : Text
    = "${matchbox_ip}:8081"

let ssh_authorized_key
    : Text
    = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpw3cIAdtWOYUkb6UOAIcLuRzItoo4oZMzr/hzZYq4E openpgp:0xFAAA0172"

let matchbox_ca_crt_path
    : Text
    = env:ROOT_PATH as Text ++ "matchbox-certificates/ca.crt"

let matchbox_client_crt_path
    : Text
    = env:ROOT_PATH as Text ++ "matchbox-certificates/client.crt"

let matchbox_client_key_path
    : Text
    = env:ROOT_PATH as Text ++ "matchbox-certificates/client.key"

let matchbox_server_crt_path
    : Text
    = env:ROOT_PATH as Text ++ "matchbox-certificates/server.crt"

let matchbox_server_key_path
    : Text
    = env:ROOT_PATH as Text ++ "matchbox-certificates/server.key"

let kubernetes_ca_crt_path
    : Text
    = env:ROOT_PATH as Text ++ "kubernetes-certificates/ca.crt"

let kubernetes_ca_key_path
    : Text
    = env:ROOT_PATH as Text ++ "kubernetes-certificates/ca.key"

let kubernetes_ca_crt_hash_path
    : Text
    = env:ROOT_PATH as Text ++ "kubernetes-certificates/ca.crt.hash"

let kubernetes_encryption_key
    : Text
    = "lxFLoK59RZmg/8FVskmmlY1by6qwg78sC5kcDZOUi+g="

let kubernetes_token
    : Text
    = "abcdef.0123456789abcdef"

let keepalived_password
    : Natural
    = 12345678

let kubernetes_certificate_key
    : Text
    = "7192c6140750450dae767c0faa7edf4c7f93af78b31105b3c2eac55c791791e8"

let nodes_path
    : Text
    = env:ROOT_PATH as Text ++ "nodes.yaml"

let variables_path
    : Text
    = env:ROOT_PATH as Text ++ "variables.yaml"

let flatcar_kernel
    : Text
    = "/assets/flatcar/${flatcar_version}/flatcar_production_pxe.vmlinuz"

let flatcar_initrd
    : Text
    = "/assets/flatcar/${flatcar_version}/flatcar_production_pxe_image.cpio.gz"

in  { cilium_version
    , flatcar_channel
    , flatcar_network_ip_address
    , flatcar_network_ip_dhcp_ranges_end
    , flatcar_network_ip_dhcp_ranges_start
    , flatcar_network_ip_netmask
    , flatcar_network_mode
    , flatcar_network_name
    , flatcar_network_nat_ports_end
    , flatcar_network_nat_ports_start
    , flatcar_version
    , keepalived_version
    , kubernetes_config_version
    , kubernetes_ha_ip
    , kubernetes_version
    , matchbox_cidr
    , matchbox_dns_server
    , matchbox_gateway
    , matchbox_ip
    , matchbox_http_endpoint
    , matchbox_rpc_endpoint
    , ssh_authorized_key
    , matchbox_ca_crt_path
    , matchbox_client_crt_path
    , matchbox_client_key_path
    , matchbox_server_crt_path
    , matchbox_server_key_path
    , kubernetes_ca_crt_path
    , kubernetes_ca_key_path
    , kubernetes_ca_crt_hash_path
    , kubernetes_encryption_key
    , kubernetes_token
    , keepalived_password
    , kubernetes_certificate_key
    , nodes_path
    , variables_path
    , flatcar_kernel
    , flatcar_initrd
    }
