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

variable "hostname" {
  type        = string
  description = "Hostname"
  default     = "localhost"
}

variable "flatcar_channel" {
  type        = string
  description = "Flatcar Container Linux channel"
  default     = "stable"
}

variable "flatcar_version" {
  type        = string
  description = "Flatcar Container Linux version"
  default     = "current"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default     = "1.35.3"
}

variable "kubernetes_config" {
  type        = string
  description = "Kubernetes config version"
  default     = "1.35"
}

variable "cilium_version" {
  type        = string
  description = "Cilium version"
  default     = "0.19.2"
}

variable "keepalived_version" {
  type        = string
  description = "Keepalived version"
  default     = "2.3.4"
}

variable "ha_ip" {
  type        = string
  description = "Kubernetes HA IP"
  default     = "192.168.100.253"
}

locals {
  flatcar_kernel = "/assets/flatcar/${var.flatcar_version}/flatcar_production_pxe.vmlinuz"
  flatcar_initrd = "/assets/flatcar/${var.flatcar_version}/flatcar_production_pxe_image.cpio.gz"

  flatcar_etcd_init_node = {
    "flatcar-node0" = {
      mac = "52:54:00:00:00:00"
    }
  }

  flatcar_etcd_join_nodes = {
    "flatcar-node1" = {
      mac = "52:54:00:00:00:01"
    }
    "flatcar-node2" = {
      mac = "52:54:00:00:00:02"
    }
  }
}
