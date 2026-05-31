export ROOT_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

default: dhall-variables
	$(MAKE) matchbox-certificates
	$(MAKE) kubernetes-certificates
	$(MAKE) libvirt-nodes
	$(MAKE) matchbox-assets-upload
	$(MAKE) matchbox
.PHONY: default

clean: dhall-variables
	$(MAKE) matchbox-clean
	$(MAKE) libvirt-nodes-clean
	$(MAKE) kubernetes-certificates-clean
	$(MAKE) matchbox-certificates-clean
.PHONY: clean

libvirt-nodes: dhall-variables
	$(MAKE) -C libvirt-nodes
.PHONY: libvirt-nodes

libvirt-nodes-clean: dhall-variables
	$(MAKE) -C libvirt-nodes clean
.PHONY: libvirt-nodes-clean

matchbox: dhall-variables
	$(MAKE) -C matchbox
.PHONY: matchbox

matchbox-clean: dhall-variables
	$(MAKE) -C matchbox clean
.PHONY: matchbox-clean

matchbox-assets-download: dhall-variables
	FLATCAR_CHANNEL=$$(jq -r '.flatcar_channel' variables.json); \
	FLATCAR_VERSION=$$(jq -r '.flatcar_version' variables.json); \
	./get-flatcar $${FLATCAR_CHANNEL} $${FLATCAR_VERSION} matchbox-assets
.PHONY: matchbox-assets-download

matchbox-assets-upload: dhall-variables
	MATCHBOX_IP=$$(jq -r '.matchbox_ip' variables.json); \
	until \
	  rsync -rvz \
	  --rsync-path="sudo rsync" \
	  --delete \
	  matchbox-assets/ \
	  core@$${MATCHBOX_IP}:/var/lib/matchbox/assets; \
	do \
	  sleep 1; \
	done

certificates: dhall-variables kubernetes-certificates matchbox-certificates
.PHONY: certificates

kubernetes-certificates: dhall-variables
	$(MAKE) -C kubernetes-certificates
.PHONY: kubernetes-certificates

kubernetes-certificates-clean: dhall-variables
	$(MAKE) -C kubernetes-certificates clean
.PHONY: kubernetes-certificates-clean

matchbox-certificates: dhall-variables
	$(MAKE) -C matchbox-certificates
.PHONY: matchbox-certificates

matchbox-certificates-clean: dhall-variables
	$(MAKE) -C matchbox-certificates clean
.PHONY: matchbox-certificates-clean

kube-bench: dhall-variables
	KUBERNETES_VERSION=$$(jq -r '.kubernetes_config_version' variables.json); \
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
	    -t docker.io/aquasec/kube-bench:latest run --version' "$${KUBERNETES_VERSION}"
.PHONY: kube-bench

nodes.json: nodes.dhall
	dhall-to-json \
	  --file nodes.dhall \
	  --output nodes.json

variables.json: variables.dhall
	dhall-to-json \
	  --file variables.dhall \
	  --output variables.json

dhall-variables: nodes.json variables.json
	$(eval export TF_VAR_nodes_path := $(shell jq -r '.nodes_path' variables.json))
	$(eval export TF_VAR_variables_path := $(shell jq -r '.variables_path' variables.json))
.PHONY: dhall-variables
