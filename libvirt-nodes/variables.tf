variable "flatcar_network_ip_address" { type = string }
variable "flatcar_network_ip_dhcp_ranges_end" { type = string }
variable "flatcar_network_ip_dhcp_ranges_start" { type = string }
variable "flatcar_network_ip_netmask" { type = string }
variable "flatcar_network_mode" { type = string }
variable "flatcar_network_name" { type = string }
variable "flatcar_network_nat_ports_end" { type = string }
variable "flatcar_network_nat_ports_start" { type = string }
variable "flatcar_version" { type = string }
variable "flatcar_channel" { type = string }

variable "matchbox_ip" { type = string }
variable "matchbox_cidr" { type = string }
variable "matchbox_gateway" { type = string }
variable "matchbox_dns_servers" { type = string }
