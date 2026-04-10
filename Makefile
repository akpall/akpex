FLATCAR_CHANNEL := $(shell awk -F'"' '/flatcar_channel/{print $$2}' terraform.tfvars)
FLATCAR_VERSION := $(shell awk -F'"' '/flatcar_version/{print $$2}' terraform.tfvars)
MATCHBOX_IP := $(shell awk -F'"' '/matchbox_ip/{print $$2}' terraform.tfvars)

TLS_SCRIPT_PATH := scripts/tls
TLS_FILES := $(TLS_SCRIPT_PATH)/ca.crt \
	     $(TLS_SCRIPT_PATH)/server.crt \
	     $(TLS_SCRIPT_PATH)/server.key
export SAN := IP.1:$(MATCHBOX_IP)

default:
	$(MAKE) matchbox-assets-upload
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
	  core@$(MATCHBOX_IP):/var/lib/matchbox/assets; \
	do \
	  sleep 1; \
	done

matchbox:
	tofu apply -target=module.matchbox-certificates
	tofu apply
.PHONY: matchbox

certificates: $(TLS_FILES)
.PHONY: certificates

$(TLS_FILES):
	cd scripts/tls && ./cert-gen
