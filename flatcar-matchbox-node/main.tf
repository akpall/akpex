data "ct_config" "flatcar_matchbox" {
  content = templatefile("${path.module}/flatcar-matchbox.yaml", {
    server_certificate = var.server_certificate
    server_private_key = var.server_private_key
    ca_certificate     = var.ca_certificate
  })
  strict = true
}

resource "libvirt_ignition" "flatcar_matchbox" {
  name    = "${var.vm_name}.ign"
  content = data.ct_config.flatcar_matchbox.rendered
}

resource "libvirt_volume" "flatcar_base" {
  name = "flatcar-base-${var.flatcar_channel}-${var.flatcar_release}"
  pool = "default"
  create = {
    content = {
      url = "https://${var.flatcar_channel}.release.flatcar-linux.net/amd64-usr/${var.flatcar_release}/flatcar_production_qemu_image.img"
    }
  }

  target = {
    format = {
      type = "qcow2"
    }
  }
}

resource "terraform_data" "system_volume" {
  triggers_replace = {
    vm_name  = var.vm_name
    capacity = var.disk_capacity_bytes
    ignition = libvirt_ignition.flatcar_matchbox.id
    base     = libvirt_volume.flatcar_base.id
  }
}

resource "libvirt_volume" "flatcar_matchbox_system" {
  name     = "${var.vm_name}-system.qcow2"
  pool     = "default"
  capacity = var.disk_capacity_bytes

  backing_store = {
    path = libvirt_volume.flatcar_base.path
    format = {
      type = "qcow2"
    }
  }

  target = {
    format = {
      type = "qcow2"
    }
  }

  lifecycle {
    ignore_changes       = all
    replace_triggered_by = [terraform_data.system_volume]
  }
}

resource "libvirt_domain" "flatcar_matchbox" {
  name        = var.vm_name
  memory      = var.memory
  memory_unit = "MiB"
  vcpu        = var.vcpu
  type        = "kvm"
  autostart   = true
  running     = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
  }

  features = {
    acpi = true
  }

  sys_info = [
    {
      fw_cfg = {
        entry = [
          {
            name  = "opt/org.flatcar-linux/config"
            file  = libvirt_ignition.flatcar_matchbox.path
            value = ""
          }
        ]
      }
    }
  ]

  devices = {
    disks = [
      {
        driver = {
          name = "qemu"
          type = "qcow2"
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
        source = {
          volume = {
            pool   = libvirt_volume.flatcar_matchbox_system.pool
            volume = libvirt_volume.flatcar_matchbox_system.name
          }
        }
      }
    ]

    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = "flatcar_network"
          }
        }
      }
    ]

    consoles = [
      {
        type        = "pty"
        target_type = "virtio"
      }
    ]

    graphics = null
  }

  lifecycle {
    replace_triggered_by = [
      libvirt_volume.flatcar_matchbox_system.id
    ]
  }
}
