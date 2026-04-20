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
export TF_VAR_matchbox_http_endpoint := http://$(TF_VAR_matchbox_ip):8080
export TF_VAR_matchbox_rpc_endpoint := $(TF_VAR_matchbox_ip):8081

export TF_VAR_ssh_authorized_key := ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpw3cIAdtWOYUkb6UOAIcLuRzItoo4oZMzr/hzZYq4E openpgp:0xFAAA0172

export TF_VAR_matchbox_ca_crt_path     := $(shell realpath scripts/matchbox-certificates/ca.crt)
export TF_VAR_matchbox_client_crt_path := $(shell realpath scripts/matchbox-certificates/client.crt)
export TF_VAR_matchbox_client_key_path := $(shell realpath scripts/matchbox-certificates/client.key)
export TF_VAR_matchbox_server_crt_path := $(shell realpath scripts/matchbox-certificates/server.crt)
export TF_VAR_matchbox_server_key_path := $(shell realpath scripts/matchbox-certificates/server.key)

export TF_VAR_kubernetes_ca_crt_path := $(shell realpath scripts/kubernetes-certificates/ca.crt)
export TF_VAR_kubernetes_ca_key_path := $(shell realpath scripts/kubernetes-certificates/ca.key)
export TF_VAR_kubernetes_ca_crt_hash_path := $(shell realpath scripts/kubernetes-certificates/ca.crt.hash)

default:
	$(MAKE) matchbox-certificates
	$(MAKE) kubernetes-certificates
	$(MAKE) libvirt-nodes-apply
	$(MAKE) matchbox-assets-upload
	$(MAKE) matchbox-apply
.PHONY: default

clean:
	$(MAKE) matchbox-destroy
	$(MAKE) libvirt-nodes-destroy
	$(MAKE) kubernetes-certificates-clean
	$(MAKE) matchbox-certificates-clean
.PHONY: clean

libvirt-nodes-apply:
	$(MAKE) -C libvirt-nodes apply
.PHONY: libvirt-nodes-apply

libvirt-nodes-destroy:
	$(MAKE) -C libvirt-nodes destroy
.PHONY: libvirt-nodes-destroy

matchbox-apply:
	$(MAKE) -C matchbox apply
.PHONY: matchbox-apply

matchbox-destroy:
	$(MAKE) -C matchbox destroy
.PHONY: matchbox-destroy

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

certificates: $(TLS_FILES)
.PHONY: certificates

kubernetes-certificates:
	$(MAKE) -C scripts/kubernetes-certificates
.PHONY: kubernetes-certificates

kubernetes-certificates-clean:
	$(MAKE) -C scripts/kubernetes-certificates clean
.PHONY: kubernetes-certificates-clean

matchbox-certificates:
	$(MAKE) -C scripts/matchbox-certificates
.PHONY: matchbox-certificates

matchbox-certificates-clean:
	$(MAKE) -C scripts/matchbox-certificates clean
.PHONY: matchbox-certificates-clean
