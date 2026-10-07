resource "tls_private_key" "root-ca-key" {
  algorithm   = var.algorithm
  rsa_bits    = var.algorithm == "RSA" ? var.rsa_bits : null
  ecdsa_curve = var.algorithm == "ECDSA" ? var.ecdsa_curve : null
}

resource "tls_self_signed_cert" "root-ca-crt" {
  private_key_pem = tls_private_key.root-ca-key.private_key_pem

  subject {
    common_name = var.common_name
  }

  validity_period_hours = var.validity_period_hours

  is_ca_certificate = true

  allowed_uses = var.allowed_uses
}
