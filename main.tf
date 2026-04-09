module "flatcar-network" {
  source = "./flatcar-network"

  flatcar_network_ip_address           = var.flatcar_network_ip_address
  flatcar_network_ip_dhcp_ranges_end   = var.flatcar_network_ip_dhcp_ranges_end
  flatcar_network_ip_dhcp_ranges_start = var.flatcar_network_ip_dhcp_ranges_start
  flatcar_network_ip_netmask           = var.flatcar_network_ip_netmask
  flatcar_network_mode                 = var.flatcar_network_mode
  flatcar_network_name                 = var.flatcar_network_name
  flatcar_network_nat_ports_end        = var.flatcar_network_nat_ports_end
  flatcar_network_nat_ports_start      = var.flatcar_network_nat_ports_start
}