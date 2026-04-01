variable "vm_name" {
  description = "Name of the VM"
  type        = string
  default     = "flatcar-node"
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

variable "disk_capacity_bytes" {
  description = "System disk capacity in bytes (default 20 GiB)"
  type        = number
  default     = 20 * 1024 * 1024 * 1024
}
