etcd.json: etcd.yaml
	docker run --rm -i \
	  --volume ${PWD}:/pwd \
	  --workdir /pwd \
	  quay.io/coreos/butane:latest \
	  --strict \
	  --pretty \
	  < etcd.yaml \
	  > etcd.json
