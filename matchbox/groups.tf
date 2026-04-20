# worker nodes
resource "matchbox_group" "flatcar-worker" {
  for_each = local.flatcar_worker_nodes

  name    = "flatcar-worker"
  profile = matchbox_profile.flatcar-worker[each.key].name
}

# init nodes
resource "matchbox_group" "flatcar-etcd-init-stage-0" {
  for_each = local.flatcar_etcd_init_node

  name    = "${each.key}-init-stage-0"
  profile = matchbox_profile.flatcar-etcd-init-stage-0.name

  selector = {
    mac = each.value.mac
  }
}

resource "matchbox_group" "flatcar-etcd-init-stage-1" {
  for_each = local.flatcar_etcd_init_node

  name    = "${each.key}-init-stage-1"
  profile = matchbox_profile.flatcar-etcd-init-stage-1[each.key].name

  selector = {
    mac        = each.value.mac
    os_install = true
  }
}

# join nodes
resource "matchbox_group" "flatcar-etcd-join-stage-0" {
  for_each = local.flatcar_etcd_join_nodes

  name    = "${each.key}-join-stage-0"
  profile = matchbox_profile.flatcar-etcd-join-stage-0.name

  selector = {
    mac = each.value.mac
  }
}

resource "matchbox_group" "flatcar-etcd-join-stage-1" {
  for_each = local.flatcar_etcd_join_nodes

  name    = "${each.key}-join-stage-1"
  profile = matchbox_profile.flatcar-etcd-join-stage-1[each.key].name

  selector = {
    mac        = each.value.mac
    os_install = true
  }
}
