default:
	$(MAKE) apply
.PHONY: default

init:
	tofu init
.PHONY: init

apply: init
	tofu apply
.PHONY: apply

destroy: init
	tofu destroy
.PHONY: destroy
