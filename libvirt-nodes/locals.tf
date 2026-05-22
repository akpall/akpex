locals {
  nodes     = yamldecode(file(var.NODES_PATH))
  variables = yamldecode(file(var.VARIABLES_PATH))
}
