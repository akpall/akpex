output "ca-crt" {
  value = tls_self_signed_cert.root-ca-crt.cert_pem
}

output "ca-key" {
  value     = tls_private_key.root-ca-key.private_key_pem
  sensitive = true
}
