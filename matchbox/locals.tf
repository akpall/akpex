locals {
  nodes     = jsondecode(file(var.nodes_path))
  variables = jsondecode(file(var.variables_path))

  haproxy_cfg_backend = join("\n", [
    for etcd_node in local.nodes.flatcar_etcd_nodes:
      "server ${etcd_node.name} ${etcd_node.ip_address}:6443 check verify none"
  ])

  kubernetes_ca_crt      = file(local.variables.kubernetes_ca_crt_path)
  kubernetes_ca_crt_hash = trimspace(file(local.variables.kubernetes_ca_crt_hash_path))
  kubernetes_ca_key      = file(local.variables.kubernetes_ca_key_path)

  matchbox_ca_crt     = file(local.variables.matchbox_ca_crt_path)
  matchbox_client_crt = file(local.variables.matchbox_client_crt_path)
  matchbox_client_key = file(local.variables.matchbox_client_key_path)
}
