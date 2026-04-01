variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "flatcar-worker-node"
}

variable "memory_mib" {
  description = "Memory size (MiB) for the VM"
  type        = number
  default     = 2048
}

variable "vcpu" {
  description = "vCPU count for the VM"
  type        = number
  default     = 2
}
