resource "tls_private_key" "kubernetes-ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "kubernetes-ca" {
  private_key_pem = tls_private_key.kubernetes-ca.private_key_pem

  subject {
    common_name = var.kubernetes_ha_ip
  }

  validity_period_hours = 10000 * 24
  is_ca_certificate     = true

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}
