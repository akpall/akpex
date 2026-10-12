terraform {
  source = "${get_repo_root()}/modules/generate-root-ca"
}

inputs = {
  allowed_uses          = values.allowed_uses
  common_name           = values.common_name
  validity_period_hours = values.validity_period_hours
}
