
default:
	$(MAKE) certificates
	$(MAKE) kubernetes
	$(MAKE) infrastructure
	$(MAKE) matchbox-assets-upload
	$(MAKE) matchbox
.PHONY: default

certificates: $(TLS_FILES)
.PHONY: certificates

$(TLS_FILES):
	cd scripts/tls && ./cert-gen

clean:
	$(MAKE) -C matchbox clean
	$(MAKE) -C infrastructure clean
.PHONY: clean

matchbox:
	$(MAKE) -C matchbox
.PHONY: matchbox

matchbox-assets-download:
	$(MAKE) -C matchbox assets-download
.PHONY: matchbox-assets-download

infrastructure:
	$(MAKE) -C infrastructure
.PHONY: infrastructure

matchbox-assets-upload:
	$(MAKE) -C matchbox assets-upload
.PHONY: matchbox-assets-upload

kubernetes:
	$(MAKE) -C scripts/kubernetes
.PHONY: kubernetes
