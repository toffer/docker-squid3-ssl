current_dir = $(shell pwd)
build_tag = 'squid3-ssl-build-debs'

debs: build_debs copy_debs

build_debs:
		docker build -t $(build_tag) - < Dockerfile

copy_debs:
		docker run -v $(current_dir)/debs:/src/debs $(build_tag) /bin/sh -c 'cp /src/*.deb /src/debs/'
