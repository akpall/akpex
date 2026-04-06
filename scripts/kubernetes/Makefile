SHELL := /bin/bash

MASTER_IP ?= 192.168.100.253
MASTER_CLUSTER_IP ?= 10.96.0.1

default:
	$(MAKE) server.crt
	$(MAKE) ca_hash
.PHONY: default

ca.key:
	openssl genrsa -out ca.key 2048

ca.crt: ca.key
	openssl req -x509 -new -noenc -key ca.key -subj "/CN=$(MASTER_IP)" -days 10000 -out ca.crt

server.key: ca.crt
	openssl genrsa -out server.key 2048

csr.conf: csr.conf.template
	sed \
	  -e 's/<MASTER_IP>/$(MASTER_IP)/g' \
	  -e 's/<MASTER_CLUSTER_IP>/$(MASTER_CLUSTER_IP)/g' \
	  csr.conf.template > csr.conf

server.csr: server.key csr.conf
	openssl req -new -key server.key -out server.csr -config csr.conf

server.crt: server.csr ca.crt ca.key csr.conf
	openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
	  -CAcreateserial -out server.crt -days 10000 \
	  -extensions v3_ext -extfile csr.conf -sha256

ca_hash: ca.crt
	openssl x509 -pubkey -in ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | awk '{print "sha256:"$$2}' > ca_hash
