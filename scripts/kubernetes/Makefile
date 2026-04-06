SHELL := /bin/bash

MASTER_IP ?= 192.168.100.2
MASTER_CLUSTER_IP ?= 192.168.100.253

test:
	# Generate the token
	TOKEN=$(echo "$(tr -dc 'a-z0-9' < /dev/urandom | head -c 6).$(tr -dc 'a-z0-9' < /dev/urandom | head -c 16)"); \
	# Generate Kubernetes CA (used for cluster signing)
	openssl req -x509 -newkey rsa:2048 -keyout "ca.key" -out "ca.crt" -days 365 -nodes -subj "/CN=kubernetes"; \
	# Generate Front Proxy CA (used for API server aggregation)
	openssl req -x509 -newkey rsa:2048 -keyout "front-proxy-ca.key" -out "front-proxy-ca.crt" -days 365 -nodes -subj "/CN=front-proxy-ca"; \
	# Generate Service Account Signing Key
	openssl genrsa -out "sa.key" 2048; \
	openssl rsa -in "sa.key" -pubout -out "sa.pub"; \
	# Generate API server certificate (signed by Kubernetes CA)
	openssl req -new -newkey rsa:2048 -keyout "apiserver.key" -out "apiserver.csr" -nodes -subj "/CN=kube-apiserver"; \
	openssl x509 -req -in "apiserver.csr" -CA "ca.crt" -CAkey "ca.key" -CAcreateserial -out "apiserver.crt" -days 365
