TLS_FILES := tls/ca.crt tls/server.crt tls/server.key

export SAN := IP.1:192.168.100.254

default:
	tofu apply
.PHONY: default

certificate: $(TLS_FILES)

$(TLS_FILES):
	cd tls && ./cert-gen

clean:
	tofu destroy
