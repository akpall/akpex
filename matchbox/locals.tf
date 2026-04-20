locals {
  flatcar_kernel = "/assets/flatcar/${var.flatcar_version}/flatcar_production_pxe.vmlinuz"
  flatcar_initrd = "/assets/flatcar/${var.flatcar_version}/flatcar_production_pxe_image.cpio.gz"

  flatcar_etcd_init_node = {
    "flatcar-node0" = {
      mac                 = "52:54:00:00:00:00"
      interface           = "eth0"
      ip                  = "192.168.100.2"
      cidr                = 24
      dns                 = "192.168.100.1"
      gateway             = "192.168.100.1"
      keepalived_priority = 100
    }
  }

  flatcar_etcd_join_nodes = {
    "flatcar-node1" = {
      mac                 = "52:54:00:00:00:01"
      interface           = "eth0"
      ip                  = "192.168.100.3"
      cidr                = 24
      dns                 = "192.168.100.1"
      gateway             = "192.168.100.1"
      keepalived_priority = 90
    }
    "flatcar-node2" = {
      mac                 = "52:54:00:00:00:02"
      interface           = "eth0"
      ip                  = "192.168.100.4"
      cidr                = 24
      dns                 = "192.168.100.1"
      gateway             = "192.168.100.1"
      keepalived_priority = 80
    }
  }

  flatcar_all_nodes = merge(local.flatcar_etcd_init_node, local.flatcar_etcd_join_nodes)

  haproxy_cfg_backend = join("\n", [
    for key, value in local.flatcar_all_nodes :
    "server ${key} ${value.ip}:6443 check verify none"
  ])

  keepalived_password = "12345678"

  kubernetes_ca_crt      = file("./scripts/kubernetes/ca.crt")
  kubernetes_ca_key      = file("./scripts/kubernetes/ca.key")
  kubernetes_ca_crt_hash = trimspace(file("./scripts/kubernetes/ca.crt.hash"))
  kubernetes_token       = "abcdef.0123456789abcdef"
  # openssl rand -hex 32
  kubernetes_certificate_key = "7192c6140750450dae767c0faa7edf4c7f93af78b31105b3c2eac55c791791e8"
}
