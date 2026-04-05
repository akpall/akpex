FLATCAR_CHANNEL ?= stable
FLATCAR_VERSION ?= current

TLS_SCRIPT_PATH := scripts/tls
TLS_FILES := $(TLS_SCRIPT_PATH)/ca.crt \
	     $(TLS_SCRIPT_PATH)/server.crt \
	     $(TLS_SCRIPT_PATH)/server.key

export MATCHBOX_HOST ?= 192.168.100.254

export SAN := IP.1:$(MATCHBOX_HOST)

default:
	$(MAKE) matchbox-assets-download
	$(MAKE) matchbox-assets-upload
	$(MAKE) matchbox
	$(MAKE) certificates
	$(MAKE) -C infrastructure
.PHONY: default

certificates: $(TLS_FILES)
.PHONY: certificates

$(TLS_FILES):
	cd scripts/tls && ./cert-gen

matchbox-assets-download:
	./get-flatcar $(FLATCAR_CHANNEL) $(FLATCAR_VERSION)
.PHONY: matchbox-assets-download

matchbox-assets-upload:
	until \
	  rsync -rvz \
	  --rsync-path="sudo rsync" \
	  --delete \
	  assets \
	  core@$(MATCHBOX_HOST):/var/lib/matchbox/; \
	do \
	  sleep 1; \
	done
.PHONY: matchbox-assets-upload

libvirt:
	tofu apply
.PHONY: libvirt

clean:
	$(MAKE) -C matchbox clean
	$(MAKE) -C infrastructure clean
.PHONY: clean

matchbox:
	$(MAKE) -C matchbox
.PHONY: matchbox
