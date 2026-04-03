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
          order = 1
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
