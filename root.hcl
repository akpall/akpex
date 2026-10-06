locals {
  provider_versions = {
    ct = {
      source  = "poseidon/ct"
      version = "~> 0.14.0"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.9.7"
    }
  }
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    terraform {
      required_providers {
        %{for name, p in local.provider_versions~}
        ${name} = {
          source  = "${p.source}"
          version = "${p.version}"
        }
        %{endfor~}
      }
    }
  EOF
}
