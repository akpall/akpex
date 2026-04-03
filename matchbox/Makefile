TLS_FILES := tls/ca.crt tls/server.crt tls/server.key

export SAN := IP.1:192.168.100.254

default:
	tar -czvf matchbox-configs.tar.gz groups ignition profiles get-flatcar
.PHONY: default

certificate: $(TLS_FILES)

$(TLS_FILES):
	cd tls && ./cert-gen
