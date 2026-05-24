# worker nodes
resource "matchbox_group" "flatcar-worker" {
  for_each = {
    for node in local.nodes.flatcar_worker_nodes:
    node.name => node
  }

  name    = "${each.key}-worker"
  profile = matchbox_profile.flatcar-worker[each.key].name

  selector = {
    mac = each.value.mac_address
  }
}

# init nodes
resource "matchbox_group" "flatcar-etcd-init-stage-0" {
  name    = "flatcar-etcd-init-stage-0"
  profile = matchbox_profile.flatcar-etcd-init-stage-0.name

  selector = {
    mac = local.nodes.flatcar_etcd_init_node.mac_address
  }
}

resource "matchbox_group" "flatcar-etcd-init-stage-1" {
  name    = "flatcar-etcd-init-stage-1"
  profile = matchbox_profile.flatcar-etcd-init-stage-1.name

  selector = {
    mac        = local.nodes.flatcar_etcd_init_node.mac_address
    os_install = true
  }
}

# join nodes
resource "matchbox_group" "flatcar-etcd-join-stage-0" {
  for_each = {
    for node in local.nodes.flatcar_etcd_join_nodes:
    node.name => node
  }

  name    = "${each.key}-join-stage-0"
  profile = matchbox_profile.flatcar-etcd-join-stage-0.name

  selector = {
    mac = each.value.mac_address
  }
}

resource "matchbox_group" "flatcar-etcd-join-stage-1" {
  for_each = {
    for node in local.nodes.flatcar_etcd_join_nodes:
    node.name => node
  }

  name    = "${each.key}-join-stage-1"
  profile = matchbox_profile.flatcar-etcd-join-stage-1[each.key].name

  selector = {
    mac        = each.value.mac_address
    os_install = true
  }
}
