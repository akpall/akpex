locals {
  variables = yamldecode(file(var.variables_path))
}
