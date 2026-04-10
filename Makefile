FLATCAR_CHANNEL := $(shell awk -F'"' '/flatcar_channel/{print $$2}' terraform.tfvars)
FLATCAR_VERSION := $(shell awk -F'"' '/flatcar_release/{print $$2}' terraform.tfvars)

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
	  assets \
	  core@$(MATCHBOX_HOST):/var/lib/matchbox/; \
	do \
	  sleep 1; \
	done
