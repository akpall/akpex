resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name = local.variables.kubernetes_ha_ip
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
    hash=$(openssl x509 -in "${path.module}/ca.crt" -pubkey \
      | openssl rsa -pubin -outform der 2>/dev/null \
      | openssl dgst -sha256 -hex \
      | awk '{print $2}')
    printf '{"hash":"%s"}' "$hash"
  EOT
  ]

  depends_on = [local_file.ca_crt]
}

resource "local_sensitive_file" "ca_key" {
  content         = tls_private_key.ca.private_key_pem
  filename        = "${path.module}/ca.key"
  file_permission = "0600"
}

resource "local_file" "ca_crt" {
  content         = tls_self_signed_cert.ca.cert_pem
  filename        = "${path.module}/ca.crt"
  file_permission = "0644"
}

resource "local_file" "ca_crt_hash" {
  content         = "sha256:${data.external.ca_cert_hash.result["hash"]}"
  filename        = "${path.module}/ca.crt.hash"
  file_permission = "0644"
}
