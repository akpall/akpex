default: apply
.PHONY: default

init:
	tofu init
.PHONY: init

apply: init
	tofu apply
.PHONY: apply

clean: init
	tofu destroy
.PHONY: clean
