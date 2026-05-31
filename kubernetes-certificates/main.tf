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

locals {
  pubkey_b64 = replace(
    replace(
      replace(tls_private_key.ca.public_key_pem, "-----BEGIN PUBLIC KEY-----\n", ""),
      "-----END PUBLIC KEY-----\n", ""
    ),
    "\n", ""
  )

  # This is the correct approach: hash the raw DER bytes of the public key
  # base64sha256 in Terraform 1.x: sha256(string_as_utf8_bytes) — NOT what we want for binary
  # Use external data source for correctness:
  ca_cert_hash = "sha256:${data.external.ca_cert_hash.result["hash"]}"
}

data "external" "ca_cert_hash" {
  program = ["bash", "-c", "openssl x509 -in ${path.module}/ca.crt -pubkey -noout | openssl pkey -pubin -outform DER | openssl dgst -sha256 -hex | awk '{print \"{\\\"hash\\\": \\\"\" $2 \"\\\"}\"}' "]

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
  content         = local.ca_cert_hash
  filename        = "${path.module}/ca.crt.hash"
  file_permission = "0644"
}
