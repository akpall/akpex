HA_IP ?=

default:
	$(MAKE) ca.crt
	$(MAKE) ca_hash
.PHONY: default

ca.key:
	openssl genrsa -out ca.key 2048

ca.crt: ca.key
	openssl req -x509 -new -noenc -key ca.key -subj "/CN=$(HA_IP)" -days 10000 -out ca.crt

ca_hash: ca.crt
	openssl x509 -pubkey -in ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | awk '{print "sha256:"$$2}' > ca_hash

# init
#core@localhost ~ $ sudo kubeadm init --token abcdef.0123456789abcdef --upload-certs --control-plane-endpoint 192.168.100.253 --certificate-key 3206e0f0238e2f62eb2eb1d356b34f5210ed5a48a01d685684059267d734e1d0

# join
#core@localhost ~ $ sudo kubeadm join 192.168.100.253:6443 --token abcdef.0123456789abcdef --discovery-token-ca-cert-hash sha256:29c1feb22fa28ea54433b2a04eee6be705530a88a3c953efabda69cdc620c947 --control-plane --certificate-key 3206e0f0238e2f62eb2eb1d356b34f5210ed5a48a01d685684059267d734e1d0
