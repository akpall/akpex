locals {
  kubernetes_ha_ip = "192.168.100.253"
  matchbox_ip = "192.168.100.254"
  matchbox-server-ip_addresses = [local.matchbox_ip]
}
