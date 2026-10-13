resource "libvirt_network" "network" {
  autostart = true
  name      = var.name
  forward = {
    mode = "nat"
    nat = {
      ports = [
        {
          start = var.nat-ports-start
          end   = var.nat-ports-end
        }
      ]
    }
  }
  ips = [
    {
      address = var.ip_address
      netmask = var.ip_netmask
      dhcp = {
        ranges = [
          {
            start = var.ip_dhcp_ranges_start
            end   = var.ip_dhcp_ranges_end
          }
        ]
      }
    }
  ]
  dns = {
    enable = "yes"
  }
}
