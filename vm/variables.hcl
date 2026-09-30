locals {
  cilium_version = "0.19.2"

  flatcar_channel                      = "stable"
  flatcar_initrd                       = "/assets/flatcar/${local.flatcar_version}/flatcar_production_pxe_image.cpio.gz"
  flatcar_kernel                       = "/assets/flatcar/${local.flatcar_version}/flatcar_production_pxe.vmlinuz"
  flatcar_network_ip_address           = "192.168.100.1"
  flatcar_network_ip_dhcp_ranges_end   = "192.168.100.252"
  flatcar_network_ip_dhcp_ranges_start = "192.168.100.5"
  flatcar_network_ip_netmask           = "255.255.255.0"
  flatcar_network_mode                 = "nat"
  flatcar_network_name                 = "flatcar_network"
  flatcar_network_nat_ports_end        = 65535
  flatcar_network_nat_ports_start      = 1024
  flatcar_version                      = "4757.2.0"

  keepalived_password = 12345678
  keepalived_version  = "2.3.4"

  kubernetes_certificate_key = "7192c6140750450dae767c0faa7edf4c7f93af78b31105b3c2eac55c791791e8"
  kubernetes_config_version  = "1.36"
  kubernetes_encryption_key  = "lxFLoK59RZmg/8FVskmmlY1by6qwg78sC5kcDZOUi+g="
  kubernetes_ha_ip           = "192.168.100.253"
  kubernetes_token           = "abcdef.0123456789abcdef"
  kubernetes_version         = "1.36.1"

  matchbox-server-ip_addresses = [local.matchbox_ip]
  matchbox_dns_servers         = ["192.168.100.1"]
  matchbox_gateway             = "192.168.100.1"
  matchbox_http_endpoint       = "http://${local.matchbox_ip}:8080"
  matchbox_ip                  = "192.168.100.254"
  matchbox_rpc_endpoint        = "${local.matchbox_ip}:8081"

  ssh_authorized_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpw3cIAdtWOYUkb6UOAIcLuRzItoo4oZMzr/hzZYq4E openpgp:0xFAAA0172"

  flatcar-etcd-nodes = [
    {
      disk_capacity_gb = 20
      mac_address      = "52:54:00:00:00:00"
      memory           = 2048
      vcpu             = 2
      vm_name          = "flatcar-etcd-node0"
    },
    {
      disk_capacity_gb = 20
      mac_address      = "52:54:00:00:00:01"
      memory           = 2048
      vcpu             = 2
      vm_name          = "flatcar-etcd-node1"
    },
    {
      disk_capacity_gb = 20
      mac_address      = "52:54:00:00:00:02"
      memory           = 2048
      vcpu             = 2
      vm_name          = "flatcar-etcd-node2"
    }
  ]
}
