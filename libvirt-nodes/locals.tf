locals {
  nodes     = yamldecode(file(var.nodes_path))
  variables = yamldecode(file(var.variables_path))
}
