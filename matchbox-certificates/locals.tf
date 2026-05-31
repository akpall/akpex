locals {
  variables = jsondecode(file(var.variables_path))
}