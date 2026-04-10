default:
.PHONY: default

VAR_FILES := -var-file="../terraform.tfvars"

apply:
	tofu apply $(VAR_FILES)
.PHONY: apply

plan:
	tofu plan $(VAR_FILES)
.PHONY: plan
