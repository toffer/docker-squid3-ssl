Docker-Squid3-SSL
=================
A Squid3 caching proxy (with SSL enabled) in a Docker container.


Details
-------
* Ubuntu 13.10 (Saucy Salamander).
* Squid (Version 3.3.8).
* Built from source, with --enable-ssl.
* Automatically generates self-signed certificate.
* Configured to cache Docker images (default config for Squid3 doesn't handle Docker images very well.)


Running the Squid3 Proxy
------------------
### Building the Docker Image
Clone the git repo and cd into the root directory.

    $ git clone https://github.com/toffer/docker-squid3-ssl
    $ cd docker-squid3-ssl

Building the `squid3-ssl` Docker image is a 2-step process. (Read the Makefile for the actual `docker` commands.)

    $ make debs
    $ make image

The first step creates a `squid3-ssl-build` Docker image, whose purpose is to compile Squid3 from source, produce Debian packages, and copy the `.deb` files to the host filesystem.

The second step uses the Debian packages from the first step to create the `squid3-ssl` image.

By breaking up the build process into 2 steps, it's easy to create a small `squid3-ssl` image. Otherwise, if we built from source and installed it on the same image, we would have a lot of packages installed (gcc, etc.) that aren't needed for running Squid, only for building it.


### Generating the Certificate
Squid3-SSL requires a valid CA certificate and private key to run. If you would like to use your own, simply copy them into the `certs` directory. Otherwise, the following command will generate a self-signed certificate and copy it into `certs`.

    $ make certs

The self-signed certificate has the `commonName` of `proxy.docker.dev`.


### Running the Docker Image
The `squid3-SSL` image expects the CA certificate and private key to reside in the `/etc/squid3/certs` directory, but that directory is empty in the Docker image. To supply the certificate, mount the certs directory as an external volume when you run the image.

    $ docker run -d -p 3128:3128 -v /path/to/docker-squid3-ssl/certs:/etc/squid3/certs squid3-ssl


Using the Squid3 Proxy
----------------------
### Trust the Self-signed Certificate
To use the proxy, your computer needs to trust the self-signed certificate. To install the CA certificate on Ubuntu, follow these steps:

    # "proxy.docker.dev.crt" is the name of the self-signed certificate.
    $ sudo cp proxy.docker.dev.crt /usr/share/ca-certificates
    $ sudo sh -c 'echo "proxy.docker.dev.crt" >> /etc/ca-certificates.conf'
    $ sudo /usr/sbin/update-ca-certificates --fresh

Consult [this page](http://mitmproxy.org/doc/ssl.html) for instructions how to install on a different OS.


### Add Entry in /etc/hosts
In addition, your computer needs to be able to resolve the name of the proxy. The easiest way to achieve this is to add an entry in `/etc/hosts` for the proxy.

    # Example entry in /etc/hosts/
    192.168.31.28   proxy.docker.dev


### Is it Working?
Run this command twice and check the `X-Cache` header that Squid sets in the reponses. The second response should show a cache hit.

    $ curl -s -i -x http://proxy.docker.dev:3128 https://httpbin.org/ip | grep 'X-Cache:'
    X-Cache: MISS from 54ab989722f0

    $ curl -s -i -x http://proxy.docker.dev:3128 https://httpbin.org/ip | grep 'X-Cache:'
    X-Cache: HIT from 54ab989722f0


License
-------
MIT license. Copyright (c) 2013 Tom Offermann.
