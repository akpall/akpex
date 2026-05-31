default: apply
.PHONY: default

apply: init
	tofu apply
.PHONY: apply

init:
	tofu init
.PHONY: init

clean: init
	tofu destroy
.PHONY: clean
