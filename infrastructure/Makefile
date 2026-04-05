FLATCAR_CHANNEL ?=
FLATCAR_VERSION ?=

TERRAFORM_VARS := \
  -var="flatcar_channel=$(FLATCAR_CHANNEL)" \
  -var="flatcar_version=$(FLATCAR_VERSION)"

default:
	tofu apply $(TERRAFORM_VARS)
.PHONY: default

clean:
	tofu destroy
.PHONY: clean
