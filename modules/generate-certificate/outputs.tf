output "certificate-crt" {
  value = tls_locally_signed_cert.certificate-crt.cert_pem
}

output "certificate-key" {
  value     = tls_private_key.certificate-key.private_key_pem
  sensitive = true
}
