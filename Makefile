TLS_SCRIPT_PATH := scripts/tls
TLS_FILES := $(TLS_SCRIPT_PATH)/ca.crt \
	     $(TLS_SCRIPT_PATH)/server.crt \
	     $(TLS_SCRIPT_PATH)/server.key

export SAN := IP.1:192.168.100.254

certificate: $(TLS_FILES)

$(TLS_FILES) tls:
	cd scripts/tls && ./cert-gen
