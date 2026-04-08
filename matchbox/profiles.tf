# flatcar-worker
resource "matchbox_profile" "flatcar-worker" {
  name         = "flatcar-worker"
  raw_ignition = data.ct_config.flatcar-worker.rendered

  kernel = local.flatcar_kernel
  initrd = [
    local.flatcar_initrd,
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
  ]
}

data "ct_config" "flatcar-worker" {
  content = templatefile("butane/flatcar-worker.yaml", {
    ssh_authorized_key = var.ssh_authorized_key
  })
  strict = true
}

# flatcar-etcd-init-stage-0
resource "matchbox_profile" "flatcar-etcd-init-stage-0" {
  name         = "flatcar-etcd-init-stage-0"
  raw_ignition = data.ct_config.flatcar-etcd-init-stage-0.rendered

  kernel = local.flatcar_kernel
  initrd = [
    local.flatcar_initrd,
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
  ]
}

data "ct_config" "flatcar-etcd-init-stage-0" {
  content = templatefile("butane/flatcar-etcd-init-stage-0.yaml", {
    ssh_authorized_key     = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
  })
  strict = true
}

# flatcar-etcd-init-stage-1
resource "matchbox_profile" "flatcar-etcd-init-stage-1" {
  for_each = local.flatcar_etcd_init_node

  name         = "${each.key}-etcd-init-stage-1"
  raw_ignition = data.ct_config.flatcar-etcd-init-stage-1[each.key].rendered
}

data "ct_config" "flatcar-etcd-init-stage-1" {
  for_each = local.flatcar_etcd_init_node

  content = templatefile("butane/flatcar-etcd-init-stage-1.yaml", {
    ssh_authorized_key     = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
    KUBERNETES_VERSION     = var.kubernetes_version
    KUBERNETES_CONFIG      = var.kubernetes_config
    CILIUM_VERSION         = var.cilium_version
    KEEPALIVED_VERSION     = var.keepalived_version
    HA_IP                  = var.ha_ip
    HOSTNAME               = each.key
    IP                     = each.value.ip
    INTERFACE              = each.value.interface
    DNS                    = each.value.dns
    CIDR                   = each.value.cidr
    GATEWAY                = each.value.gateway
  })
  strict = true
}


# flatcar-etcd-join-stage-0
resource "matchbox_profile" "flatcar-etcd-join-stage-0" {
  name         = "flatcar-etcd-join-stage-0"
  raw_ignition = data.ct_config.flatcar-etcd-join-stage-0.rendered

  kernel = local.flatcar_kernel
  initrd = [
    local.flatcar_initrd,
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${var.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
  ]
}

data "ct_config" "flatcar-etcd-join-stage-0" {
  content = templatefile("butane/flatcar-etcd-join-stage-0.yaml", {
    ssh_authorized_key     = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
  })
  strict = true
}

# flatcar-etcd-join-stage-1
resource "matchbox_profile" "flatcar-etcd-join-stage-1" {
  for_each = local.flatcar_etcd_join_nodes

  name         = "${each.key}-etcd-join-stage-1"
  raw_ignition = data.ct_config.flatcar-etcd-join-stage-1[each.key].rendered
}

data "ct_config" "flatcar-etcd-join-stage-1" {
  for_each = local.flatcar_etcd_join_nodes

  content = templatefile("butane/flatcar-etcd-join-stage-1.yaml", {
    ssh_authorized_key     = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
    KUBERNETES_VERSION     = var.kubernetes_version
    KUBERNETES_CONFIG      = var.kubernetes_config
    CILIUM_VERSION         = var.cilium_version
    KEEPALIVED_VERSION     = var.keepalived_version
    HA_IP                  = var.ha_ip
    HOSTNAME               = each.key
  })
  strict = true
}
