# flatcar-worker
resource "matchbox_profile" "flatcar-worker" {
  for_each = {
    for node in local.nodes.flatcar_worker_nodes:
    node.name => node
  }

  name         = "${each.key}-worker"
  raw_ignition = data.ct_config.flatcar-worker[each.key].rendered

  kernel = local.variables.flatcar_kernel
  initrd = [
    local.variables.flatcar_initrd,
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${local.variables.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
  ]
}

data "ct_config" "flatcar-worker" {
  for_each = {
    for node in local.nodes.flatcar_worker_nodes:
    node.name => node
  }

  content = templatefile("${path.module}/butane/flatcar-worker.yaml", {
    SSH_AUTHORIZED_KEY         = local.variables.ssh_authorized_key
    HOSTNAME                   = each.key
    INTERFACE                  = each.value.interface
    KUBERNETES_VERSION         = local.variables.kubernetes_version
    KUBERNETES_CONFIG_VERSION  = local.variables.kubernetes_config_version
    KUBERNETES_HA_IP           = local.variables.kubernetes_ha_ip
    KUBERNETES_CERTIFICATE_KEY = local.variables.kubernetes_certificate_key
    KUBERNETES_CA_CRT_HASH     = local.kubernetes_ca_crt_hash
    KUBERNETES_TOKEN           = local.variables.kubernetes_token
  })
  strict = true
}

# flatcar-etcd-init-stage-0
resource "matchbox_profile" "flatcar-etcd-init-stage-0" {
  name         = "flatcar-etcd-init-stage-0"
  raw_ignition = data.ct_config.flatcar-etcd-init-stage-0.rendered

  kernel = local.variables.flatcar_kernel
  initrd = [
    local.variables.flatcar_initrd,
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${local.variables.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
  ]
}

data "ct_config" "flatcar-etcd-init-stage-0" {
  content = templatefile("${path.module}/butane/flatcar-etcd-init-stage-0.yaml", {
    SSH_AUTHORIZED_KEY     = local.variables.ssh_authorized_key
    MATCHBOX_HTTP_ENDPOINT = local.variables.matchbox_http_endpoint
  })
  strict = true
}

# flatcar-etcd-init-stage-1
resource "matchbox_profile" "flatcar-etcd-init-stage-1" {
  name         = "flatcar-etcd-init-stage-1"
  raw_ignition = data.ct_config.flatcar-etcd-init-stage-1.rendered
}

data "ct_config" "flatcar-etcd-init-stage-1" {
  content = templatefile("${path.module}/butane/flatcar-etcd-init-stage-1.yaml", {
    SSH_AUTHORIZED_KEY         = local.variables.ssh_authorized_key
    MATCHBOX_HTTP_ENDPOINT     = local.variables.matchbox_http_endpoint
    KUBERNETES_VERSION         = local.variables.kubernetes_version
    KUBERNETES_CONFIG_VERSION  = local.variables.kubernetes_config_version
    CILIUM_VERSION             = local.variables.cilium_version
    KEEPALIVED_VERSION         = local.variables.keepalived_version
    KUBERNETES_HA_IP           = local.variables.kubernetes_ha_ip
    HOSTNAME                   = local.nodes.flatcar_etcd_init_node.name
    IP                         = local.nodes.flatcar_etcd_init_node.ip_address
    INTERFACE                  = local.nodes.flatcar_etcd_init_node.interface
    DNS                        = local.nodes.flatcar_etcd_init_node.dns
    CIDR                       = local.nodes.flatcar_etcd_init_node.cidr
    GATEWAY                    = local.nodes.flatcar_etcd_init_node.gateway
    KEEPALIVED_PRIORITY        = local.nodes.flatcar_etcd_init_node.keepalived_priority
    KEEPALIVED_PASSWORD        = local.variables.keepalived_password
    HAPROXY_CFG_BACKEND        = local.haproxy_cfg_backend
    KUBERNETES_CA_CRT          = local.kubernetes_ca_crt
    KUBERNETES_TOKEN           = local.variables.kubernetes_token
    KUBERNETES_CERTIFICATE_KEY = local.variables.kubernetes_certificate_key
    KUBERNETES_CA_KEY          = local.kubernetes_ca_key
    KUBERNETES_ENCRYPTION_KEY = local.variables.kubernetes_encryption_key
  })
  strict = true
}


# flatcar-etcd-join-stage-0
resource "matchbox_profile" "flatcar-etcd-join-stage-0" {
  name         = "flatcar-etcd-join-stage-0"
  raw_ignition = data.ct_config.flatcar-etcd-join-stage-0.rendered

  kernel = local.variables.flatcar_kernel
  initrd = [
    local.variables.flatcar_initrd,
  ]

  args = [
    "initrd=flatcar_production_pxe_image.cpio.gz",
    "flatcar.config.url=${local.variables.matchbox_http_endpoint}/ignition?uuid=$${uuid}&mac=$${mac:hexhyp}",
    "flatcar.first_boot=yes",
  ]
}

data "ct_config" "flatcar-etcd-join-stage-0" {
  content = templatefile("${path.module}/butane/flatcar-etcd-join-stage-0.yaml", {
    SSH_AUTHORIZED_KEY     = local.variables.ssh_authorized_key
    MATCHBOX_HTTP_ENDPOINT = local.variables.matchbox_http_endpoint
  })
  strict = true
}

# flatcar-etcd-join-stage-1
resource "matchbox_profile" "flatcar-etcd-join-stage-1" {
  for_each = {
    for node in local.nodes.flatcar_etcd_join_nodes:
    node.name => node
  }

  name         = "${each.key}-etcd-join-stage-1"
  raw_ignition = data.ct_config.flatcar-etcd-join-stage-1[each.key].rendered
}

data "ct_config" "flatcar-etcd-join-stage-1" {
  for_each = {
    for node in local.nodes.flatcar_etcd_join_nodes:
    node.name => node
  }

  content = templatefile("${path.module}/butane/flatcar-etcd-join-stage-1.yaml", {
    SSH_AUTHORIZED_KEY         = local.variables.ssh_authorized_key
    MATCHBOX_HTTP_ENDPOINT     = local.variables.matchbox_http_endpoint
    KUBERNETES_VERSION         = local.variables.kubernetes_version
    KUBERNETES_CONFIG_VERSION  = local.variables.kubernetes_config_version
    CILIUM_VERSION             = local.variables.cilium_version
    KEEPALIVED_VERSION         = local.variables.keepalived_version
    KUBERNETES_HA_IP           = local.variables.kubernetes_ha_ip
    HOSTNAME                   = each.key
    IP                         = each.value.ip_address
    INTERFACE                  = each.value.interface
    DNS                        = each.value.dns
    CIDR                       = each.value.cidr
    GATEWAY                    = each.value.gateway
    KEEPALIVED_PRIORITY        = each.value.keepalived_priority
    KEEPALIVED_PASSWORD        = local.variables.keepalived_password
    HAPROXY_CFG_BACKEND        = local.haproxy_cfg_backend
    KUBERNETES_CERTIFICATE_KEY = local.variables.kubernetes_certificate_key
    KUBERNETES_CA_CRT_HASH     = local.kubernetes_ca_crt_hash
    KUBERNETES_TOKEN           = local.variables.kubernetes_token
  })
  strict = true
}
