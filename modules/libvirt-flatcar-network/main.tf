resource "libvirt_network" "flatcar_network" {
  autostart = true
  name      = "flatcar_network"
  forward = {
    mode = "nat"
    nat = {
      ports = [
        {
          start = 1024
          end   = 65535
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
      }
    }
  ]
  dns = {
    enable = "yes"
  }
}
