terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

# Generate 4096-bit RSA private key
resource "tls_private_key" "ca" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate self-signed CA certificate
resource "tls_self_signed_cert" "ca" {
  private_key_pem = tls_private_key.ca.private_key_pem

  subject {
    common_name = "fake-ca"
  }

  validity_period_hours = 87600 # 10 years (365 * 24 * 10)

  is_ca_certificate = true

  allowed_uses = [
    "digital_signature",
    "cert_signing",
    "crl_signing",
  ]
}

# Write certificate to file
resource "local_file" "ca_cert" {
  content         = tls_self_signed_cert.ca.cert_pem
  filename        = "${path.module}/ca.crt"
  file_permission = "0644"
}

# Write private key to file (sensitive)
resource "local_sensitive_file" "ca_key" {
  content         = tls_private_key.ca.private_key_pem
  filename        = "${path.module}/ca.key"
  file_permission = "0600"
}

# Generate 2048-bit RSA private key for client
resource "tls_private_key" "client" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate CSR for client
resource "tls_cert_request" "client" {
  private_key_pem = tls_private_key.client.private_key_pem

  subject {
    common_name = "fake-client"
  }
}

# Sign client cert with the CA
resource "tls_locally_signed_cert" "client" {
  cert_request_pem   = tls_cert_request.client.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 8760 # 1 year

  is_ca_certificate = false

  allowed_uses = [
    "digital_signature",
    "content_commitment", # Non Repudiation
    "key_encipherment",
    "client_auth",        # TLS Web Client Authentication
  ]
}

# Write client certificate to file
resource "local_file" "client_cert" {
  content         = tls_locally_signed_cert.client.cert_pem
  filename        = "${path.module}/client.crt"
  file_permission = "0644"
}

# Write client private key to file
resource "local_sensitive_file" "client_key" {
  content         = tls_private_key.client.private_key_pem
  filename        = "${path.module}/client.key"
  file_permission = "0600"
}

# Generate 2048-bit RSA private key for server
resource "tls_private_key" "server" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Generate CSR for server
resource "tls_cert_request" "server" {
  private_key_pem = tls_private_key.server.private_key_pem

  subject {
    common_name = "fake-server"
  }

  ip_addresses = ["192.168.100.254"]
}

# Sign server cert with the CA
resource "tls_locally_signed_cert" "server" {
  cert_request_pem   = tls_cert_request.server.cert_request_pem
  ca_private_key_pem = tls_private_key.ca.private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca.cert_pem

  validity_period_hours = 8760 # 1 year

  is_ca_certificate = false

  allowed_uses = [
    "digital_signature",
    "key_encipherment",
    "server_auth", # TLS Web Server Authentication
  ]
}

# Write server certificate to file
resource "local_file" "server_cert" {
  content         = tls_locally_signed_cert.server.cert_pem
  filename        = "${path.module}/server.crt"
  file_permission = "0644"
}

# Write server private key to file
resource "local_sensitive_file" "server_key" {
  content         = tls_private_key.server.private_key_pem
  filename        = "${path.module}/server.key"
  file_permission = "0600"
}
