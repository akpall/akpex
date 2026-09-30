variable "flatcar-etcd-nodes" {
  type = map(object({
    disk_capacity_gb = number
    mac_address      = string
    memory           = number
    vcpu             = number
    vm_name          = string
  }))
}
