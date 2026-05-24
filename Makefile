export ROOT_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

default: dhall-variables
	$(MAKE) matchbox-certificates
	$(MAKE) kubernetes-certificates
	$(MAKE) libvirt-nodes-apply
	$(MAKE) matchbox-assets-upload
	$(MAKE) matchbox-apply
.PHONY: default

clean: dhall-variables
	$(MAKE) matchbox-destroy
	$(MAKE) libvirt-nodes-destroy
	$(MAKE) kubernetes-certificates-clean
	$(MAKE) matchbox-certificates-clean
.PHONY: clean

libvirt-nodes-apply: dhall-variables
	echo $${TF_VAR_nodes_path}
	$(MAKE) -C libvirt-nodes apply
.PHONY: libvirt-nodes-apply

libvirt-nodes-destroy: dhall-variables
	$(MAKE) -C libvirt-nodes destroy
.PHONY: libvirt-nodes-destroy

matchbox-apply: dhall-variables
	$(MAKE) -C matchbox apply
.PHONY: matchbox-apply

matchbox-destroy: dhall-variables
	$(MAKE) -C matchbox destroy
.PHONY: matchbox-destroy

matchbox-assets-download: dhall-variables
	./get-flatcar $(FLATCAR_CHANNEL) $(FLATCAR_VERSION) matchbox-assets
.PHONY: matchbox-assets-download

matchbox-assets-upload: dhall-variables
	$(eval MATCHBOX_IP := $(shell yq -r '.matchbox_ip' variables.yaml))
	until \
	  rsync -rvz \
	  --rsync-path="sudo rsync" \
	  --delete \
	  matchbox-assets/ \
	  core@$(MATCHBOX_IP):/var/lib/matchbox/assets; \
	do \
	  sleep 1; \
	done

certificates: $(TLS_FILES) dhall-variables
.PHONY: certificates

kubernetes-certificates: dhall-variables
	$(MAKE) -C scripts/kubernetes-certificates
.PHONY: kubernetes-certificates

kubernetes-certificates-clean: dhall-variables
	$(MAKE) -C scripts/kubernetes-certificates clean
.PHONY: kubernetes-certificates-clean

matchbox-certificates: dhall-variables
	$(MAKE) -C scripts/matchbox-certificates
.PHONY: matchbox-certificates

matchbox-certificates-clean: dhall-variables
	$(MAKE) -C scripts/matchbox-certificates clean
.PHONY: matchbox-certificates-clean

kube-bench: dhall-variables
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

nodes.yaml: nodes.dhall
	dhall-to-yaml \
	  --file nodes.dhall \
	  --output nodes.yaml

variables.yaml: variables.dhall
	dhall-to-yaml \
	  --file variables.dhall \
	  --output variables.yaml

dhall-variables: nodes.yaml variables.yaml
	$(eval export TF_VAR_nodes_path := $(shell yq -r '.nodes_path' variables.yaml))
	$(eval export TF_VAR_variables_path := $(shell yq -r '.variables_path' variables.yaml))
.PHONY: dhall-variables
