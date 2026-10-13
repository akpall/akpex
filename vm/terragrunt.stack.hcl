locals {
  provider_libvirt_version  = "~> 0.9.9"
  provider_ignition_version = ">= 2.6.0, <2.7.0"
  provider_matchbox_version = "~> 0.5.4"

  flatcar_network_block         = "192.168.100.0/24"
  flatcar_network_cidr          = tonumber(split("/", local.flatcar_network_block)[1])
  flatcar_network_dhcp_end      = cidrhost(local.flatcar_network_block, -2)
  flatcar_network_dhcp_start    = cidrhost(local.flatcar_network_block, 3)
  flatcar_network_dns_servers   = [local.flatcar_network_gateway]
  flatcar_network_gateway       = cidrhost(local.flatcar_network_block, 1)
  flatcar_network_matchbox_node = cidrhost(local.flatcar_network_block, 2)
  flatcar_network_netmask       = cidrnetmask(local.flatcar_network_block)

  flatcar_channel                      = "stable"
  flatcar_initrd                       = "/assets/flatcar/${local.flatcar_version}/flatcar_production_pxe_image.cpio.gz"
  flatcar_kernel                       = "/assets/flatcar/${local.flatcar_version}/flatcar_production_pxe.vmlinuz"
  flatcar_network_ip_address           = "192.168.100.1"
  flatcar_network_ip_dhcp_ranges_end   = "192.168.100.252"
  flatcar_network_ip_dhcp_ranges_start = "192.168.100.5"
  flatcar_network_ip_netmask           = "255.255.255.0"
  flatcar_network_name                 = "flatcar_network"
  flatcar_production_image_bin         = "${local.flatcar_production_url}/flatcar_production_image.bin.bz2"
  flatcar_production_pxe_image_cpio    = "${local.flatcar_production_url}/flatcar_production_pxe_image.cpio.gz"
  flatcar_production_pxe_vmlinuz       = "${local.flatcar_production_url}/flatcar_production_pxe.vmlinuz"
  flatcar_production_qemu_image        = "${local.flatcar_production_url}/flatcar_production_qemu_image.img"
  flatcar_production_url               = "https://${local.flatcar_channel}.release.flatcar-linux.net/amd64-usr/${local.flatcar_version}"
  flatcar_version                      = "4757.2.1"

  nodes = {
    "flatcar-matchbox-node" = {
      disk_capacity_gb = 20
      mac_address      = "52:54:00:00:00:00"
      memory           = 2048
      vcpu             = 2
      ip               = local.flatcar_network_matchbox_node
    }
  }

  ssh_authorized_keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpw3cIAdtWOYUkb6UOAIcLuRzItoo4oZMzr/hzZYq4E openpgp:0xFAAA0172"]
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

unit "flatcar-network" {
  source = "../units/generate-libvirt-network"
  path   = "flatcar-network"

  values = {
    name                     = "flatcar_network"
    ip_address               = local.flatcar_network_gateway
    ip_dhcp_ranges_start     = local.flatcar_network_dhcp_start
    ip_dhcp_ranges_end       = local.flatcar_network_dhcp_end
    ip_netmask               = local.flatcar_network_netmask
    provider_libvirt_version = local.provider_libvirt_version
  }
}

unit "flatcar-matchbox-node" {
  source = "../units/generate-libvirt-matchbox-node"
  path   = "flatcar-matchbox-node"

  autoinclude {
    dependency "matchbox-ca" {
      config_path = unit.matchbox-ca.path

      mock_outputs = {
        ca-crt = "ca-crt"
      }
    }

    dependency "matchbox-server-certificate" {
      config_path = unit.matchbox-server-certificate.path

      mock_outputs = {
        certificate-key = "certificate-key"
        certificate-crt = "certificate-crt"
      }
    }

    inputs = {
      matchbox_ca_crt     = dependency.matchbox-ca.outputs.ca-crt
      matchbox_server_key = dependency.matchbox-server-certificate.outputs.certificate-key
      matchbox_server_crt = dependency.matchbox-server-certificate.outputs.certificate-crt
    }
  }

  values = {
    disk_capacity_gb              = local.nodes.flatcar-matchbox-node.disk_capacity_gb
    flatcar_channel               = local.flatcar_channel
    flatcar_production_qemu_image = local.flatcar_production_qemu_image
    flatcar_urls = [
      local.flatcar_production_image_bin,
      local.flatcar_production_pxe_image_cpio,
      local.flatcar_production_pxe_vmlinuz
    ]
    flatcar_version           = local.flatcar_version
    mac_address               = local.nodes.flatcar-matchbox-node.mac_address
    matchbox_cidr             = local.flatcar_network_cidr
    matchbox_dns_servers      = local.flatcar_network_dns_servers
    matchbox_gateway          = local.flatcar_network_gateway
    matchbox_ip               = local.nodes.flatcar-matchbox-node.ip
    memory                    = local.nodes.flatcar-matchbox-node.memory
    ssh_authorized_keys       = local.ssh_authorized_keys
    vcpu                      = local.nodes.flatcar-matchbox-node.vcpu
    vm_name                   = "flatcar-matchbox-node"
    provider_libvirt_version  = local.provider_libvirt_version
    provider_ignition_version = local.provider_ignition_version
  }
}
