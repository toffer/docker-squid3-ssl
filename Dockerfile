# Dockerfile: Build debian packages for Squid3, with SSL enabled.
# http://www.squid-cache.org/

FROM stackbrew/ubuntu:saucy
MAINTAINER Tom Offermann <tom@offermann.us>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu saucy main universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# Install debian build tools
RUN apt-get -y install build-essential fakeroot devscripts equivs lintian

# Download source
RUN mkdir /src
RUN cd /src && apt-get source squid3

# Install build dependencies for Squid
RUN apt-get -y install libssl-dev
RUN cd /src && mk-build-deps -i -r -t 'apt-get -y' squid3

# Edit debian/rules to build with SSL
RUN sed -i 's/--enable-ecap/--enable-ecap --enable-ssl --enable-ssl-crtd/' /src/squid3-3.3.8/debian/rules

# Build debs
RUN cd /src/squid3-3.3.8 && debuild -us -uc -b
