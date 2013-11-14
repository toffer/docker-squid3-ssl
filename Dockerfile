# Dockerfile for Squid3, with SSL enabled.
# http://www.squid-cache.org/

FROM stackbrew/ubuntu:saucy
MAINTAINER Tom Offermann <tom@offermann.us>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ saucy-updates main" >> /etc/apt/sources.list
RUN echo "deb http://security.ubuntu.com/ubuntu saucy-security main" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu saucy main" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ saucy-updates main" >> /etc/apt/sources.list
RUN echo "deb-src http://security.ubuntu.com/ubuntu saucy-security main" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# Install dependencies
RUN apt-get -y install apache2 logrotate squid-langpack ca-certificates
RUN apt-get -y install libgssapi-krb5-2 libltdl7 libecap2 libnetfilter-conntrack3

# Install from locally generated .deb files
ADD debs /root/
RUN dpkg -i /root/*.deb
RUN rm /root/*.deb

# Install configuration files
ADD config/squid3-ssl.conf /etc/squid3/squid3-ssl.conf
ADD config/openssl.cnf /etc/squid3/openssl.cnf

# Add certs directory
ADD certs /etc/squid3/certs

# Initialize dynamic certs directory
RUN /usr/lib/squid3/ssl_crtd -c -s /var/lib/ssl_db
RUN chown -R proxy:proxy /var/lib/ssl_db

# Create cache directory
RUN mkdir /srv/squid3
RUN chown proxy:proxy /srv/squid3
RUN touch /srv/squid3/init_volume
VOLUME /srv/squid3

# Install run.sh and make-certs.sh
ADD bin /usr/local/bin/
RUN chmod 755 /usr/local/bin/run.sh /usr/local/bin/make-certs.sh

EXPOSE 3128
CMD ["/usr/local/bin/run.sh"]
