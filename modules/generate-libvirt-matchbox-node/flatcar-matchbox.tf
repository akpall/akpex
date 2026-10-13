data "ignition_config" "flatcar-matchbox" {
  users = [
    data.ignition_user.core.rendered
  ]
  files = [
    data.ignition_file.etc-matchbox-server-crt.rendered,
    data.ignition_file.etc-matchbox-server-key.rendered,
    data.ignition_file.etc-matchbox-ca-crt.rendered,
    data.ignition_file.opt-bin-matchbox-download-asset.rendered
  ]
  systemd = [
    data.ignition_systemd_unit.matchbox.rendered,
    data.ignition_systemd_unit.dnsmasq.rendered,
    data.ignition_systemd_unit.get-matchbox-assets.rendered
  ]
}

data "ignition_user" "core" {
  name                = "core"
  ssh_authorized_keys = var.ssh_authorized_keys
}

data "ignition_file" "etc-matchbox-server-crt" {
  path = "/etc/matchbox/server.crt"
  mode = 384
  contents {
    source = "data:;base64,${base64encode(var.matchbox_server_crt)}"
  }
}

data "ignition_file" "etc-matchbox-server-key" {
  path = "/etc/matchbox/server.key"
  mode = 384
  contents {
    source = "data:;base64,${base64encode(var.matchbox_server_key)}"
  }
}

data "ignition_file" "etc-matchbox-ca-crt" {
  path = "/etc/matchbox/ca.crt"
  mode = 384
  contents {
    source = "data:;base64,${base64encode(var.matchbox_ca_crt)}"
  }
}

data "ignition_file" "opt-bin-matchbox-download-asset" {
  path = "/opt/bin/matchbox-download-asset"
  mode = 493
  contents {
    source = "data:;base64,${base64encode(<<-EOF
      #!/usr/bin/env bash
      set -uo pipefail

      DEST="/var/lib/matchbox/assets"
      mkdir -p "$DEST"

      _attempt() {
        local url="$1" path="$2" expected actual

        curl -fsSL -o "$path"         "$url"         || return 1
        curl -fsSL -o "$path.DIGESTS" "$url.DIGESTS" || return 1

        expected=$(awk '/^# SHA512 HASH/ {f=1; next} f {print $1; exit}' "$path.DIGESTS")
        [[ "$expected" =~ ^[0-9a-f]{128}$ ]] || return 1

        actual=$(sha512sum "$path" | awk '{print $1}')
        [[ "$expected" == "$actual" ]]
      }

      download_and_verify() {
        local url="$1" path n
        path="$DEST/$(basename "$url")"

        while true; do
          _attempt "$url" "$path" && return 0
          rm -f "$path" "$path.DIGESTS"
          sleep 5
        done
        return 1
      }

      download_and_verify "$1"
    EOF
    )}"
  }
}

data "ignition_systemd_unit" "matchbox" {
  name    = "matchbox.service"
  content = <<-EOF
    [Unit]
    Description=matchbox service
    After=docker.service get-matchbox-assets.service
    Requires=docker.service get-matchbox-assets.service
    [Service]
    ExecStartPre=/usr/bin/mkdir -p /etc/matchbox
    ExecStart=/usr/bin/docker run \
              --name matchbox \
              --rm \
              -v /etc/matchbox:/etc/matchbox:Z,ro \
              -v /var/lib/matchbox:/var/lib/matchbox:Z \
              -p 8080:8080 \
              -p 8081:8081 \
              quay.io/poseidon/matchbox \
              -address=0.0.0.0:8080 \
              -rpc-address=0.0.0.0:8081 \
              -log-level=debug
    ExecStop=/usr/bin/docker stop matchbox
    [Install]
    WantedBy=multi-user.target
  EOF
}

data "ignition_systemd_unit" "dnsmasq" {
  name    = "dnsmasq.service"
  content = <<-EOF
    [Unit]
    Description=matchbox service
    After=docker.service matchbox.service
    Requires=docker.service matchbox.service
    [Service]
    ExecStart=/usr/bin/docker run \
              --name dnsmasq \
              --rm \
              --cap-add=NET_ADMIN \
              --net=host \
              quay.io/poseidon/dnsmasq:v0.5.0-47-g28ff327 \
              -d \
              -q \
              --dhcp-range=192.168.100.254,proxy,255.255.255.0 \
              --enable-tftp --tftp-root=/var/lib/tftpboot \
              --dhcp-userclass=set:ipxe,iPXE \
              --pxe-service=tag:#ipxe,x86PC,"PXE chainload to iPXE",undionly.kpxe \
              --pxe-service=tag:ipxe,x86PC,"iPXE",http://192.168.100.254:8080/boot.ipxe \
              --pxe-service=tag:#ipxe,X86-64_EFI,"PXE chainload to iPXE UEFI",ipxe.efi \
              --pxe-service=tag:ipxe,X86-64_EFI,"iPXE UEFI",http:///192.168.100.254:8080/boot.ipxe \
              --log-queries \
              --log-dhcp \
              --port=0
    ExecStop=/usr/bin/docker stop dnsmasq
    [Install]
    WantedBy=multi-user.target
  EOF
}

data "ignition_systemd_unit" "get-matchbox-assets" {
  name    = "get-matchbox-assets.service"
  enabled = true
  content = <<-EOF
    [Unit]
    Description=gets flatcar assets for matchbox
    Wants=network-online.target
    After=network-online.target

    [Service]
    Type=oneshot
    RemainAfterExit=yes
    TimeoutStartSec=infinity
    %{for u in var.flatcar_urls~}
    ExecStart=/opt/bin/matchbox-download-asset "${u}"
    %{endfor~}

    [Install]
    WantedBy=multi-user.target
  EOF
}
