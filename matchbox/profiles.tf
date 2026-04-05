// flatcar-worker
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

# flatcar-etcd-install-stage-0
resource "matchbox_profile" "flatcar-etcd-install-stage-0" {
  name         = "flatcar-etcd-install-stage-0"
  raw_ignition = data.ct_config.flatcar-etcd-install-stage-0.rendered

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

data "ct_config" "flatcar-etcd-install-stage-0" {
  content = templatefile("butane/flatcar-etcd-stage-0.yaml", {
    ssh_authorized_key     = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
  })
  strict = true
}


# flatcar-etcd-install
resource "matchbox_profile" "flatcar-etcd-install-stage-1" {
  name         = "flatcar-etcd-install-stage-1"
  raw_ignition = data.ct_config.flatcar-etcd-install-stage-1.rendered

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

data "ct_config" "flatcar-etcd-install-stage-1" {
  content = templatefile("butane/flatcar-etcd-stage-1.yaml", {
    ssh_authorized_key     = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
    KUBERNETES_VERSION     = var.kubernetes_version
    KUBERNETES_CONFIG      = var.kubernetes_config
    CILIUM_VERSION         = var.cilium_version
  })
  strict = true
}
