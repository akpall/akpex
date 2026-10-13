terraform {
  source = "${get_repo_root()}/modules/generate-libvirt-matchbox-node"
}

inputs = {
  disk_capacity_gb              = values.disk_capacity_gb
  flatcar_channel               = values.flatcar_channel
  flatcar_production_qemu_image = values.flatcar_production_qemu_image
  flatcar_urls                  = values.flatcar_urls
  flatcar_version               = values.flatcar_version
  mac_address                   = values.mac_address
  matchbox_cidr                 = values.matchbox_cidr
  matchbox_dns_servers          = values.matchbox_dns_servers
  matchbox_gateway              = values.matchbox_gateway
  matchbox_ip                   = values.matchbox_ip
  memory                        = values.memory
  ssh_authorized_keys           = values.ssh_authorized_keys
  vcpu                          = values.vcpu
  vm_name                       = values.vm_name
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
        ignition = {
          source = "community-terraform-providers/ignition"
          version = "${values.provider_ignition_version}"
        }
      }
    }
  EOF
}
