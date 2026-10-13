terraform {
  source = "${get_repo_root()}/modules/generate-libvirt-network"
}

inputs = {
  name                 = values.name
  ip_address           = values.ip_address
  ip_dhcp_ranges_end   = values.ip_dhcp_ranges_end
  ip_dhcp_ranges_start = values.ip_dhcp_ranges_start
  ip_netmask           = values.ip_netmask
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_providers {
        libvirt = {
          source  = "dmacvicar/libvirt"
          version = "${values.provider_libvirt_version}"
        }
      }
    }
  EOF
}
