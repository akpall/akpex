resource "libvirt_network" "flatcar_network" {
  autostart = true
  name      = var.flatcar_network_name
  forward = {
    mode = var.flatcar_network_mode
    nat = {
      ports = [
        {
          start = var.flatcar_network_nat_ports_start
          end   = var.flatcar_network_nat_ports_end
        }
      ]
    }
  }
  ips = [
    {
      address = var.flatcar_network_ip_address
      netmask = var.flatcar_network_ip_netmask
      dhcp = {
        ranges = [
          {
            start = var.flatcar_network_ip_dhcp_ranges_start
            end   = var.flatcar_network_ip_dhcp_ranges_end
          }
        ]
        hosts = [
          for node in var.nodes.flatcar_all_nodes : {
            ip   = node.ip_address
            mac  = node.mac_address
            name = node.name
          }
        ]
      }
    }
  ]
  dns = {
    enable = "yes"
    host = [
      for node in var.nodes.flatcar_all_nodes : {
        ip = node.ip_address
        hostnames = [
          {
            hostname = node.name
          }
        ]
      }
    ]
  }
}
