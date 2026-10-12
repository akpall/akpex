unit "matchbox-ca" {
  source = "../units/generate-root-ca"
  path   = "matchbox-ca"
  values = {
    allowed_uses          = ["digital_signature", "cert_signing"]
    common_name           = "matchbox-ca"
    validity_period_hours = 87600
  }
}

unit "matchbox-client-certificate" {
  source = "../units/generate-certificate"
  path   = "matchbox-client-certificate"

  autoinclude {
    dependency "matchbox-ca" {
      config_path = unit.matchbox-ca.path

      mock_outputs = {
        ca-key = "ca-key"
        ca-crt = "ca-crt"
      }
    }

    inputs = {
      ca_private_key_pem = dependency.matchbox-ca.outputs.ca-key
      ca_cert_pem        = dependency.matchbox-ca.outputs.ca-crt
    }
  }

  values = {
    allowed_uses = [
      "digital_signature",
      "content_commitment",
      "key_encipherment",
      "client_auth"
    ]
    common_name           = "matchbox-client-certificate"
    validity_period_hours = 8760
  }
}

unit "matchbox-server-certificate" {
  source = "../units/generate-certificate"
  path   = "matchbox-server-certificate"

  autoinclude {
    dependency "matchbox-ca" {
      config_path = unit.matchbox-ca.path

      mock_outputs = {
        ca-key = "ca-key"
        ca-crt = "ca-crt"
      }
    }

    inputs = {
      ca_private_key_pem = dependency.matchbox-ca.outputs.ca-key
      ca_cert_pem        = dependency.matchbox-ca.outputs.ca-crt
    }
  }

  values = {
    allowed_uses = [
      "digital_signature",
      "content_commitment",
      "key_encipherment",
      "client_auth"
    ]
    common_name           = "matchbox-client-certificate"
    validity_period_hours = 8760
  }
}
