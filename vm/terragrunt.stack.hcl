locals {
  provider_libvirt_version  = "~> 0.9.9"
  provider_ignition_version = "~> 2.7.2"
  provider_matchbox_version = "~> 0.5.4"

  flatcar_network_block       = "192.168.100.0/24"
  flatcar_network_cidr        = tonumber(split("/", local.flatcar_network_block)[1])
  flatcar_network_dhcp_end    = cidrhost(local.flatcar_network_block, -2)
  flatcar_network_dhcp_start  = cidrhost(local.flatcar_network_block, 2)
  flatcar_network_dns_servers = [local.flatcar_network_gateway]
  flatcar_network_gateway     = cidrhost(local.flatcar_network_block, 1)
  flatcar_network_netmask     = cidrnetmask(local.flatcar_network_block)
}

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

unit "flatcar-libvirt-network" {
  source = "../units/generate-libvirt-network"
  path   = "flatcar-libvirt-network"

  values = {
    name                     = "flatcar_network"
    ip_address               = local.flatcar_network.gateway
    ip_dhcp_ranges_start     = local.flatcar_network.dhcp_start
    ip_dhcp_ranges_end       = local.flatcar_network.dhcp_end
    ip_netmask               = local.flatcar_network.netmask
    provider_libvirt_version = local.provider_libvirt_version
  }
}
