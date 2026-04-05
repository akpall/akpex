variable "matchbox_http_endpoint" {
  type        = string
  description = "Matchbox HTTP read-only endpoint (e.g. http://matchbox.example.com:8080)"
}

variable "matchbox_rpc_endpoint" {
  type        = string
  description = "Matchbox gRPC API endpoint, without the protocol (e.g. matchbox.example.com:8081)"
}

variable "ssh_authorized_key" {
  type        = string
  description = "SSH public key to set as an authorized_key on machines"
}

variable "flatcar_version" {
  type        = string
  description = "Flatcar Container Linux version"
  default     = "current"
}

locals {
  flatcar_kernel = "/assets/flatcar/${var.flatcar_version}/flatcar_production_pxe.vmlinuz"
  flatcar_initrd = "/assets/flatcar/${var.flatcar_version}/flatcar_production_pxe_image.cpio.gz"

  flatcar_etcd_nodes = {
    "flatcar-node0" = {
      mac = "52:54:00:00:00:00"
    }
    "flatcar-node1" = {
      mac = "52:54:00:00:00:01"
    }
    "flatcar-node2" = {
      mac = "52:54:00:00:00:02"
    }
  }
}