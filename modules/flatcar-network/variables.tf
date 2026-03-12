variable "network_name" {
  type = string
}

variable "network_mode" {
  type    = string
  default = "nat"
}

variable "network_nat_ports_start" {
  type    = number
  default = 1024
}

variable "network_nat_ports_end" {
  type    = number
  default = 65535
}

variable "network_ip_address" {
  type    = string
  default = "192.168.100.1"
}

variable "network_ip_netmask" {
  type    = string
  default = "255.255.255.0"
}

variable "network_ip_dhcp_ranges_start" {
  type    = string
  default = "192.168.100.2"
}

variable "network_ip_dhcp_ranges_end" {
  type    = string
  default = "192.168.100.254"
}
