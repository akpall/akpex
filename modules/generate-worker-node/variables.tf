variable "flatcar-worker-nodes" {
  type = map(object({
    mac_address = string
    memory      = number
    vcpu        = number
    vm_name     = string
  }))
}
