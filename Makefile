include variables.mk

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
	./get-flatcar $(flatcar_channel) $(flatcar_version) matchbox-assets
.PHONY: matchbox-assets-download

matchbox-assets-upload:
	until \
	  rsync -rvz \
	  --rsync-path="sudo rsync" \
	  --delete \
	  matchbox-assets/ \
	  core@$(matchbox_ip):/var/lib/matchbox/assets; \
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

kube-bench:
	ssh core@192.168.100.2 \
	  'docker run \
	    --pid=host \
	    --rm \
	    -e KUBECONFIG=/.kube/config \
	    -v $$(which kubectl):/usr/local/mount-from-host/bin/kubectl \
	    -v /etc:/etc:ro \
	    -v /usr/share/baselayout/passwd:/etc/passwd:ro \
	    -v /usr/share/baselayout/group:/etc/group:ro \
	    -v /var:/var:ro \
	    -v ~/.kube:/.kube \
	    -t docker.io/aquasec/kube-bench:latest run --version $(kubernetes_config_version)'
.PHONY: kube-bench

variables.yaml: variables.mk
	@printf '%s\n' \
	  "cilium_version: \"${CILIUM_VERSION}\"" \
	  "flatcar_channel: \"${FLATCAR_CHANNEL}\"" \
	  "flatcar_network_ip_address: \"${FLATCAR_NETWORK_IP_ADDRESS}\"" \
	  "flatcar_network_ip_dhcp_ranges_end: \"${FLATCAR_NETWORK_IP_DHCP_RANGES_END}\"" \
	  "flatcar_network_ip_dhcp_ranges_start: \"${FLATCAR_NETWORK_IP_DHCP_RANGES_START}\"" \
	  "flatcar_network_ip_netmask: \"${FLATCAR_NETWORK_IP_NETMASK}\"" \
	  "flatcar_network_mode: \"${FLATCAR_NETWORK_MODE}\"" \
	  "flatcar_network_name: \"${FLATCAR_NETWORK_NAME}\"" \
	  "flatcar_network_nat_ports_end: \"${FLATCAR_NETWORK_NAT_PORTS_END}\"" \
	  "flatcar_network_nat_ports_start: \"${FLATCAR_NETWORK_NAT_PORTS_START}\"" \
	  "flatcar_version: \"${FLATCAR_VERSION}\"" \
	  "keepalived_version: \"${KEEPALIVED_VERSION}\"" \
	  "kubernetes_config_version: \"${KUBERNETES_CONFIG_VERSION}\"" \
	  "kubernetes_ha_ip: \"${KUBERNETES_HA_IP}\"" \
	  "kubernetes_version: \"${KUBERNETES_VERSION}\"" \
	  "matchbox_cidr: \"${MATCHBOX_CIDR}\"" \
	  "matchbox_dns_servers: \"${MATCHBOX_DNS_SERVERS}\"" \
	  "matchbox_gateway: \"${MATCHBOX_GATEWAY}\"" \
	  "matchbox_ip: \"${MATCHBOX_IP}\"" \
	  "matchbox_http_endpoint: \"${MATCHBOX_HTTP_ENDPOINT}\"" \
	  "matchbox_rpc_endpoint: \"${MATCHBOX_RPC_ENDPOINT}\"" \
	  "ssh_authorized_key: \"${SSH_AUTHORIZED_KEY}\"" \
	  "matchbox_ca_crt_path: \"${MATCHBOX_CA_CRT_PATH}\"" \
	  "matchbox_client_crt_path: \"${MATCHBOX_CLIENT_CRT_PATH}\"" \
	  "matchbox_client_key_path: \"${MATCHBOX_CLIENT_KEY_PATH}\"" \
	  "matchbox_server_crt_path: \"${MATCHBOX_SERVER_CRT_PATH}\"" \
	  "matchbox_server_key_path: \"${MATCHBOX_SERVER_KEY_PATH}\"" \
	  "kubernetes_ca_crt_path: \"${KUBERNETES_CA_CRT_PATH}\"" \
	  "kubernetes_ca_key_path: \"${KUBERNETES_CA_KEY_PATH}\"" \
	  "kubernetes_ca_crt_hash_path: \"${KUBERNETES_CA_CRT_HASH_PATH}\"" \
	  "kubernetes_encryption_key: \"${KUBERNETES_ENCRYPTION_KEY}\"" \
	> $@
