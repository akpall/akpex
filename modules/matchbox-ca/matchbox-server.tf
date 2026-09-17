resource "tls_private_key" "matchbox-server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "matchbox-server" {
  private_key_pem = tls_private_key.matchbox-server.private_key_pem

  subject {
    common_name = "matchbox-server"
  }

  ip_addresses = var.matchbox-server-ip_addresses
}

resource "tls_locally_signed_cert" "matchbox-server" {
  cert_request_pem   = tls_cert_request.matchbox-server.cert_request_pem
  ca_private_key_pem = tls_private_key.matchbox-ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.matchbox-ca.cert_pem

  validity_period_hours = 8760

  is_ca_certificate = false

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}
