resource "matchbox_group" "flatcar-worker" {
  name    = "flatcar-worker"
  profile = matchbox_profile.flatcar-worker.name
}

resource "matchbox_group" "flatcar-etcd-install-stage-0" {
  for_each = local.flatcar_etcd_nodes

  name    = "${each.key}-install"
  profile = matchbox_profile.flatcar-etcd-install.name

  selector = {
    "mac" : each.value.mac
  }
}

resource "matchbox_group" "flatcar-etcd-install-stage-1" {
  for_each = local.flatcar_etcd_nodes

  name    = each.key
  profile = matchbox_profile.flatcar-worker.name

  selector = {
    mac : each.value.mac
    etcd-install = true
  }
}
