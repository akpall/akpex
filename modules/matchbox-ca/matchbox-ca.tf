resource "tls_private_key" "matchbox-ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "matchbox-ca" {
  private_key_pem = tls_private_key.matchbox-ca.private_key_pem

  subject {
    common_name = "matchbox"
  }

  validity_period_hours = 87600

  is_ca_certificate = true

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}
