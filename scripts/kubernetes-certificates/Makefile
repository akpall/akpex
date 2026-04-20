default:
	$(MAKE) ca.crt
	$(MAKE) ca.crt.hash
.PHONY: default

ca.key:
	openssl genrsa -out ca.key 2048

ca.crt: ca.key
	openssl req -x509 -new -noenc -key ca.key -subj "/CN=$(TF_VAR_kubernetes_ha_ip)" -days 10000 -out ca.crt

ca.crt.hash: ca.crt
	openssl x509 -pubkey -in ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | awk '{print "sha256:"$$2}' > ca.crt.hash

clean:
	-rm ca.crt
	-rm ca.crt.hash
	-rm ca.key
