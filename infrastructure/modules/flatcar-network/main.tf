resource "libvirt_network" "flatcar_network" {
  autostart = true
  name      = var.network_name
  forward = {
    mode = var.network_mode
    nat = {
      ports = [
        {
          start = var.network_nat_ports_start
          end   = var.network_nat_ports_end
        }
      ]
    }
  }
  ips = [
    {
      address = var.network_ip_address
      netmask = var.network_ip_netmask
      dhcp = {
        ranges = [
          {
            start = var.network_ip_dhcp_ranges_start
            end   = var.network_ip_dhcp_ranges_end
          }
        ]
      }
    }
  ]
}
