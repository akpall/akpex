variable "algorithm" {
  type    = string
  default = "ECDSA"

  validation {
    condition     = contains(["RSA", "ECDSA", "ED25519"], var.algorithm)
    error_message = "algorithm must be one of: [\"RSA\", \"ECDSA\", \"ED25519\"]"
  }
}

variable "ecdsa_curve" {
  type    = string
  default = "P384"

  validation {
    condition     = contains(["P224", "P256", "P384", "P521"], var.ecdsa_curve)
    error_message = "ecdsa_curve must be one of: [\"P224\", \"P256\", \"P384\", \"P521\"]"
  }
}

variable "rsa_bits" {
  type    = number
  default = 4096
}

variable "common_name" {
  type = string
}

variable "validity_period_hours" {
  type = number
}

variable "allowed_uses" {
  type = list(string)

  validation {
    condition = alltrue([
      for use in var.allowed_uses :
      contains([
        "any_extended", "cert_signing", "client_auth", "code_signing",
        "content_commitment", "crl_signing", "data_encipherment", "decipher_only",
        "digital_signature", "email_protection", "encipher_only", "ipsec_end_system",
        "ipsec_tunnel", "ipsec_user", "key_agreement", "key_encipherment",
        "microsoft_commercial_code_signing", "microsoft_kernel_code_signing",
        "microsoft_server_gated_crypto", "netscape_server_gated_crypto", "ocsp_signing",
        "server_auth", "timestamping"
      ], use)
    ])
    error_message = <<-EOF
      allowed_uses can contain only:
        any_extended
        cert_signing
        client_auth
        code_signing
        content_commitment
        crl_signing
        data_encipherment
        decipher_only
        digital_signature
        email_protection
        encipher_only
        ipsec_end_system
        ipsec_tunnel
        ipsec_user
        key_agreement
        key_encipherment
        microsoft_commercial_code_signing
        microsoft_kernel_code_signing
        microsoft_server_gated_crypto
        netscape_server_gated_crypto
        ocsp_signing
        server_auth
        timestamping
    EOF
  }
}

variable "ca_private_key_pem" {}

variable "ca_cert_pem" {}
