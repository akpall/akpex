resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name = "matchbox-server"
  }

  ip_addresses = [local.variables.matchbox_ip]
}

resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 8760

  is_ca_certificate = false

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth",
  ]
}

resource "local_file" "server_cert" {
  content         = tls_locally_signed_cert.server.cert_pem
  filename        = "${path.module}/server.crt"
  file_permission = "0644"
}

resource "local_sensitive_file" "server_key" {
  content         = tls_private_key.server.private_key_pem
  filename        = "${path.module}/server.key"
  file_permission = "0600"
}
