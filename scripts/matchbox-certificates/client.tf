resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name = "matchbox-client"
  }
}

resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 8760

  is_ca_certificate = false

  allowed_uses = [
    "digital_signature",
    "content_commitment",
    "key_encipherment",
    "client_auth",
  ]
}

resource "local_file" "client_cert" {
  content         = tls_locally_signed_cert.client.cert_pem
  filename        = "${path.module}/client.crt"
  file_permission = "0644"
}

resource "local_sensitive_file" "client_key" {
  content         = tls_private_key.client.private_key_pem
  filename        = "${path.module}/client.key"
  file_permission = "0600"
}
