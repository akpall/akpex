export CILIUM_VERSION := 0.19.2

export FLATCAR_CHANNEL := stable
export FLATCAR_NETWORK_IP_ADDRESS := 192.168.100.1
export FLATCAR_NETWORK_IP_DHCP_RANGES_END := 192.168.100.252
export FLATCAR_NETWORK_IP_DHCP_RANGES_START := 192.168.100.5
export FLATCAR_NETWORK_IP_NETMASK := 255.255.255.0
export FLATCAR_NETWORK_MODE := nat
export FLATCAR_NETWORK_NAME := flatcar_network
export FLATCAR_NETWORK_NAT_PORTS_END := 65535
export FLATCAR_NETWORK_NAT_PORTS_START := 1024
export FLATCAR_VERSION := 4593.2.1

export KEEPALIVED_VERSION := 2.3.4

export KUBERNETES_CONFIG_VERSION := 1.36
export KUBERNETES_HA_IP := 192.168.100.253
export KUBERNETES_VERSION := 1.36.1

export MATCHBOX_CIDR := 24
export MATCHBOX_DNS_SERVERS := 192.168.100.1
export MATCHBOX_GATEWAY := 192.168.100.1
export MATCHBOX_IP := 192.168.100.254
export MATCHBOX_HTTP_ENDPOINT := http://$(MATCHBOX_IP):8080
export MATCHBOX_RPC_ENDPOINT := $(MATCHBOX_IP):8081

export SSH_AUTHORIZED_KEY := ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOpw3cIAdtWOYUkb6UOAIcLuRzItoo4oZMzr/hzZYq4E openpgp:0xFAAA0172

export MATCHBOX_CA_CRT_PATH     := $(shell realpath scripts/matchbox-certificates/ca.crt)
export MATCHBOX_CLIENT_CRT_PATH := $(shell realpath scripts/matchbox-certificates/client.crt)
export MATCHBOX_CLIENT_KEY_PATH := $(shell realpath scripts/matchbox-certificates/client.key)
export MATCHBOX_SERVER_CRT_PATH := $(shell realpath scripts/matchbox-certificates/server.crt)
export MATCHBOX_SERVER_KEY_PATH := $(shell realpath scripts/matchbox-certificates/server.key)

export KUBERNETES_CA_CRT_PATH := $(shell realpath scripts/kubernetes-certificates/ca.crt)
export KUBERNETES_CA_KEY_PATH := $(shell realpath scripts/kubernetes-certificates/ca.key)
export KUBERNETES_CA_CRT_HASH_PATH := $(shell realpath scripts/kubernetes-certificates/ca.crt.hash)
# head -c 32 /dev/urandom | base64
export KUBERNETES_ENCRYPTION_KEY := lxFLoK59RZmg/8FVskmmlY1by6qwg78sC5kcDZOUi+g=

export TF_VAR_NODES_PATH := $(shell realpath nodes.yaml)
export TF_VAR_VARIABLES_PATH := $(shell realpath variables.yaml)
