output "matchbox-ca-pub" {
  value = tls_self_signed_cert.matchbox-ca.cert_pem
}

output "matchbox-server-pub" {
  value = tls_locally_signed_cert.matchbox-server.cert_pem
}

output "matchbox-server-key" {
  value     = tls_private_key.matchbox-server.private_key_pem
  sensitive = true
}
