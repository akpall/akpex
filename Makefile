MATCHBOX_HOST := 192.168.100.254

TLS_SCRIPT_PATH := scripts/tls
TLS_FILES := $(TLS_SCRIPT_PATH)/ca.crt \
	     $(TLS_SCRIPT_PATH)/server.crt \
	     $(TLS_SCRIPT_PATH)/server.key

export SAN := IP.1:$(MATCHBOX_HOST)

default:
	$(MAKE) certificate
.PHONY: default

certificate: $(TLS_FILES)
.PHONY: certificate

$(TLS_FILES):
	cd scripts/tls && ./cert-gen

matchbox-assets:
	until \
	  rsync -rvz \
	  --rsync-path="sudo rsync" \
	  --delete \
	  assets \
	  core@$(MATCHBOX_HOST):/var/lib/matchbox/; \
	do \
	  sleep 1; \
	done
.PHONY: matchbox-assets
