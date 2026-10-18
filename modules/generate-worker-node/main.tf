resource "libvirt_domain" "flatcar_node" {
  for_each = var.flatcar-worker-nodes

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
        mac = {
          address = each.value.mac_address
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
