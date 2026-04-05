FLATCAR_CHANNEL ?= stable
FLATCAR_VERSION ?= current

TLS_SCRIPT_PATH := scripts/tls
TLS_FILES := $(TLS_SCRIPT_PATH)/ca.crt \
	     $(TLS_SCRIPT_PATH)/server.crt \
	     $(TLS_SCRIPT_PATH)/server.key

export MATCHBOX_HOST ?= 192.168.100.254

export SAN := IP.1:$(MATCHBOX_HOST)

default:
	$(MAKE) certificates
	$(MAKE) -C infrastructure
	$(MAKE) -C matchbox
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
