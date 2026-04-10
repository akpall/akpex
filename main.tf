module "flatcar-network" {
  source = "./flatcar-network"

  flatcar_network_ip_address           = var.flatcar_network_ip_address
  flatcar_network_ip_dhcp_ranges_end   = var.flatcar_network_ip_dhcp_ranges_end
  flatcar_network_ip_dhcp_ranges_start = var.flatcar_network_ip_dhcp_ranges_start
  flatcar_network_ip_netmask           = var.flatcar_network_ip_netmask
  flatcar_network_mode                 = var.flatcar_network_mode
  flatcar_network_name                 = var.flatcar_network_name
  flatcar_network_nat_ports_end        = var.flatcar_network_nat_ports_end
  flatcar_network_nat_ports_start      = var.flatcar_network_nat_ports_start
}

module "flatcar-etcd-init_node" {
  for_each = local.flatcar_etcd_init_nodes

  source  = "./flatcar-etcd-node"
  vm_name = each.key

  disk_capacity_bytes = each.value.disk_capacity_bytes
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-etcd-join_node" {
  for_each = local.flatcar_etcd_join_nodes

  source  = "./flatcar-etcd-node"
  vm_name = each.key

  disk_capacity_bytes = each.value.disk_capacity_bytes
  mac_address         = each.value.mac_address
  memory              = each.value.memory
  vcpu                = each.value.vcpu
}

module "flatcar-worker-nodes" {
  for_each = local.flatcar_worker_nodes

  source  = "./flatcar-worker-node"
  vm_name = each.key

  mac_address = each.value.mac_address
  memory      = each.value.memory
  vcpu        = each.value.vcpu
}

module "flatcar-matchbox-node" {
  for_each = local.flatcar_matchbox_nodes

  source  = "./flatcar-matchbox-node"
  vm_name = each.key

  ca_certificate      = tls_self_signed_cert.matchbox_ca_crt.cert_pem
  disk_capacity_bytes = each.value.disk_capacity_bytes
  flatcar_channel     = var.flatcar_channel
  flatcar_release     = var.flatcar_release
  memory              = each.value.memory
  server_certificate  = tls_locally_signed_cert.matchbox_server_crt.cert_pem
  server_private_key  = tls_private_key.matchbox_server_key.private_key_pem
  vcpu                = each.value.vcpu
}

resource "tls_private_key" "matchbox_ca_key" {
  algorithm = "ED25519"
}

resource "tls_self_signed_cert" "matchbox_ca_crt" {
  private_key_pem = resource.tls_private_key.matchbox_ca_key.private_key_pem

  subject {
    common_name  = "MATCHBOX-CA"
  }

  validity_period_hours = 3650 * 24

is_ca_certificate = true

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

resource "tls_private_key" "matchbox_server_key" {
  algorithm = "ED25519"
}

resource "tls_cert_request" "matchbox_server_csr" {
  private_key_pem = tls_private_key.matchbox_server_key.private_key_pem

  subject {
    common_name = "MATCHBOX-SERVER"
  }

  ip_addresses = [var.matchbox_ip]
}

resource "tls_locally_signed_cert" "matchbox_server_crt" {
  cert_request_pem   = tls_cert_request.matchbox_server_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.matchbox_ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.matchbox_ca_crt.cert_pem

  validity_period_hours = 365 * 24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}

resource "tls_private_key" "matchbox_client_key" {
  algorithm = "ED25519"
}

resource "tls_cert_request" "matchbox_client_csr" {
  private_key_pem = tls_private_key.matchbox_client_key.private_key_pem

  subject {
    common_name = "MATCHBOX-CLIENT"
  }
}

resource "tls_locally_signed_cert" "matchbox_client_crt" {
  cert_request_pem   = tls_cert_request.matchbox_client_csr.cert_request_pem
  ca_private_key_pem = tls_private_key.matchbox_ca_key.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.matchbox_ca_crt.cert_pem

  validity_period_hours = 365 * 24

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "content_commitment", # nonRepudiation
    "client_auth",
  ]
}
