TLS_FILES := ca.crt server.crt server.key

export SAN := IP.1:$(TF_VAR_matchbox_ip)

default:
	$(MAKE) $(TLS_FILES)

$(TLS_FILES):
	./cert-gen

clean:
	-rm -r \
	  ca.crt \
	  ca.key \
	  client.crt \
	  client.key \
	  index.txt \
	  index.txt.attr \
	  index.txt.attr.old \
	  index.txt.old \
	  newcerts \
	  serial \
	  serial.old \
	  server.crt \
	  server.key
