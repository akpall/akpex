# locals {
#   provider_versions = {
#     libvirt = {
#       source  = "dmacvicar/libvirt"
#       version = "~> 0.9.9"
#     }
#     ignition = {
#       source  = "community-terraform-providers/ignition"
#       version = "~> 2.7.2"
#     }
#     matchbox = {
#       source  = "poseidon/matchbox"
#       version = "~> 0.5.4"
#     }
#   }
# }

# generate "versions" {
#   path      = "versions.tf"
#   if_exists = "overwrite_terragrunt"
#   contents  = <<-EOF
#     terraform {
#       required_providers {
#         %{for name, p in local.provider_versions~}
#         ${name} = {
#           source  = "${p.source}"
#           version = "${p.version}"
#         }
#         %{endfor~}
#       }
#     }
#   EOF
# }
