resource "libvirt_volume" "flatcar_disk" {
  name     = "${var.vm_name}-data.qcow2"
  pool     = "default"
  capacity = var.disk_capacity_bytes
  target = {
    format = {
      type = "qcow2"
    }
  }
}

resource "libvirt_domain" "flatcar_node" {
  name        = var.vm_name
  memory      = var.memory_mib
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
      }
    ]
    disks = [
      {
        boot = {
          order = 2
        }
        source = {
          volume = {
            pool   = resource.libvirt_volume.flatcar_disk.pool
            volume = resource.libvirt_volume.flatcar_disk.name
          }
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
