FLATCAR_CHANNEL ?=
FLATCAR_VERSION ?=

KUBERNETES_VERSION ?=
KUBERNETES_CONFIG ?=

CILIUM_VERSION ?=

TERRAFORM_VARS := \
  -var="flatcar_channel=$(FLATCAR_CHANNEL)" \
  -var="flatcar_version=$(FLATCAR_VERSION)" \
  -var="kubernetes_version=$(KUBERNETES_VERSION)" \
  -var="kubernetes_config=$(KUBERNETES_CONFIG)" \
  -var="cilium_version=$(CILIUM_VERSION)"

default:
	tofu apply $(TERRAFORM_VARS)
.PHONY: default

clean:
	tofu destroy

assets-download:
	./get-flatcar $(FLATCAR_CHANNEL) $(FLATCAR_VERSION)
.PHONY: matchbox-assets-download

assets-upload:
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
