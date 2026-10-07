resource "tls_private_key" "certificate-key" {
  algorithm   = var.algorithm
  rsa_bits    = var.algorithm == "RSA" ? var.rsa_bits : null
  ecdsa_curve = var.algorithm == "ECDSA" ? var.ecdsa_curve : null
}

resource "tls_cert_request" "certificate-request" {
  private_key_pem = tls_private_key.certificate-key.private_key_pem

  subject {
    common_name = var.common_name
  }
}

resource "tls_locally_signed_cert" "certificate-crt" {
  cert_request_pem   = tls_cert_request.certificate-request.cert_request_pem
  ca_private_key_pem = var.ca_private_key_pem
  ca_cert_pem        = var.ca_cert_pem

  validity_period_hours = var.validity_period_hours

  allowed_uses = var.allowed_uses
}
