resource "libvirt_volume" "flatcar_disk" {
  for_each = var.flatcar-etcd-nodes

  name     = "${each.key}-data.qcow2"
  pool     = "default"
  capacity = each.value.disk_capacity_gb * 1024 * 1024 * 1024
  target = {
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_domain" "flatcar_node" {
  for_each = var.flatcar-etcd-nodes

  name        = each.key
  memory      = each.value.memory
  memory_unit = "MiB"
  vcpu        = each.value.vcpu
  type        = "kvm"
  autostart   = true
  running     = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    bios = {
      reboot_timeout = 0
    }
  }

  features = {
    acpi = true
  }

  devices = {
    interfaces = [
      {
        boot = {
          order = 3
        }
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = "flatcar_network"
            boot = {
              order = 1
            }
          }
        }
        mac = {
          address = each.value.mac_address
        }
      }
    ]
    disks = [
      {
        boot = {
          order = 2
        }
        source = {
          volume = {
            pool   = resource.libvirt_volume.flatcar_disk[each.key].pool
            volume = resource.libvirt_volume.flatcar_disk[each.key].name
          }
        }
        driver = {
          type = "qcow2"
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }
      },
      {
        boot = {
          order = 1
        }
        device = "cdrom"
        target = {
          dev = "sda"
          bus = "sata"
        }
      }
    ]
    consoles = [
      {
        type        = "pty"
        target_type = "virtio"
      }
    ]
    graphics = [
      {
        spice = {

        }
      }
    ]
    videos = [
      {
        model = {
          type    = "virtio"
          primary = "yes"
          heads   = 1
        }
      }
    ]
  }
}
