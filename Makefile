export TF_VAR_cilium_version := 0.19.2

export TF_VAR_flatcar_channel := stable
export TF_VAR_flatcar_network_ip_address := 192.168.100.1
export TF_VAR_flatcar_network_ip_dhcp_ranges_end := 192.168.100.252
export TF_VAR_flatcar_network_ip_dhcp_ranges_start := 192.168.100.5
export TF_VAR_flatcar_network_ip_netmask := 255.255.255.0
export TF_VAR_flatcar_network_mode := nat
export TF_VAR_flatcar_network_name := flatcar_network
export TF_VAR_flatcar_network_nat_ports_end := 65535
export TF_VAR_flatcar_network_nat_ports_start := 1024
export TF_VAR_flatcar_version := 4459.2.4

export TF_VAR_keepalived_version := 2.3.4

export TF_VAR_kubernetes_config_version := 1.35
export TF_VAR_kubernetes_ha_ip := 192.168.100.253
export TF_VAR_kubernetes_version := 1.35.3

export TF_VAR_matchbox_cidr := 24
export TF_VAR_matchbox_dns_servers := 192.168.100.1
export TF_VAR_matchbox_gateway := 192.168.100.1
export TF_VAR_matchbox_ip := 192.168.100.254

export TF_VAR_ssh_authorized_key := ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpw3cIAdtWOYUkb6UOAIcLuRzItoo4oZMzr/hzZYq4E openpgp:0xFAAA0172

TLS_SCRIPT_PATH := scripts/tls
TLS_FILES := $(TLS_SCRIPT_PATH)/ca.crt \
	     $(TLS_SCRIPT_PATH)/server.crt \
	     $(TLS_SCRIPT_PATH)/server.key
export SAN := IP.1:$(TF_VAR_matchbox_ip)

default:
	$(MAKE) certificates
	$(MAKE) libvirt-nodes-apply
	$(MAKE) matchbox-assets-upload
	$(MAKE) matchbox
.PHONY: default

clean:
	tofu clean
.PHONY: clean

matchbox-assets-download:
	./get-flatcar $(FLATCAR_CHANNEL) $(FLATCAR_VERSION) matchbox-assets
.PHONY: matchbox-assets-download

matchbox-assets-upload:
	until \
	  rsync -rvz \
	  --rsync-path="sudo rsync" \
	  --delete \
	  matchbox-assets/ \
	  core@$(TF_VAR_matchbox_ip):/var/lib/matchbox/assets; \
	do \
	  sleep 1; \
	done

matchbox:
	$(MAKE) -C matchbox apply
.PHONY: matchbox

certificates: $(TLS_FILES)
.PHONY: certificates

$(TLS_FILES):
	cd scripts/tls && ./cert-gen

libvirt-nodes-apply:
	$(MAKE) -C libvirt-nodes apply
.PHONY: libvirt-nodes-apply

libvirt-nodes-destroy:
	$(MAKE) -C libvirt-nodes destroy
.PHONY: libvirt-nodes-destroy
