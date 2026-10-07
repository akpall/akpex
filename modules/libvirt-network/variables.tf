variable "ip_address" {
  type = string
}

variable "ip_dhcp_ranges_end" {
  type = string
}

variable "ip_dhcp_ranges_start" {
  type = string
}

variable "ip_netmask" {
  type = string
}

variable "name" {
  type = string
}

variable "nat-ports-end" {
  type    = number
  default = 65535
}

variable "nat-ports-start" {
  type    = number
  default = 1024
}
