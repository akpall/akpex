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

# flatcar-etcd-install
resource "matchbox_profile" "flatcar-etcd-install" {
  name         = "flatcar-etcd-install"
  raw_ignition = data.ct_config.flatcar-etcd-install.rendered

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

data "ct_config" "flatcar-etcd-install" {
  content = templatefile("butane/flatcar-etcd-install.yaml", {
    ssh_authorized_key = var.ssh_authorized_key
    matchbox_http_endpoint = var.matchbox_http_endpoint
  })
  strict = true
}
