locals {
  nodes     = jsondecode(file(var.nodes_path))
  variables = jsondecode(file(var.variables_path))
}