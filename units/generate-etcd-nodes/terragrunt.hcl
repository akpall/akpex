terraform {
  source = "${get_repo_root()}/modules/generate-etcd-node"
}

inputs = {
  nodes              = values.nodes
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
