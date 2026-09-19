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

data "external" "ca_cert_hash" {
  program = ["bash", "-c", <<-EOT
    set -euo pipefail
    cert=$(jq -r '.cert')
    hash=$(printf '%s' "$cert" \
      | openssl x509 -pubkey -noout \
      | openssl rsa -pubin -outform der 2>/dev/null \
      | openssl dgst -sha256 -hex \
      | awk '{print $2}')
    printf '{"hash":"%s"}' "$hash"
  EOT
  ]

  query = {
    cert = tls_self_signed_cert.kubernetes-ca.cert_pem
  }
}
