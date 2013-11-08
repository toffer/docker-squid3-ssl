# Dockerfile for Squid3, with SSL enabled.
# http://www.squid-cache.org/

FROM stackbrew/ubuntu:saucy
MAINTAINER Tom Offermann <tom@offermann.us>

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main restricted" > /etc/apt/sources.list
RUN echo "deb http://archive.ubuntu.com/ubuntu/ saucy-updates main restricted" >> /etc/apt/sources.list
RUN echo "deb http://security.ubuntu.com/ubuntu saucy-security main restricted" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu saucy main restricted" >> /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ saucy-updates main restricted" >> /etc/apt/sources.list
RUN echo "deb-src http://security.ubuntu.com/ubuntu saucy-security main restricted" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get -y upgrade

# Install dependencies
RUN apt-get -y install apache2 logrotate squid-langpack ca-certificates
RUN apt-get -y install libgssapi-krb5-2 libltdl7 libecap2 libnetfilter-conntrack3

# Install from locally generated .deb files
ADD debs /root/
RUN dpkg -i /root/*.deb
RUN rm /root/*.deb

# Install configuration file
ADD config/squid3-ssl.conf /etc/squid3/squid3-ssl.conf

# Initialize dynamic certs directory
RUN /usr/lib/squid3/ssl_crtd -c -s /var/lib/ssl_db
RUN chown -R proxy:proxy /var/lib/ssl_db

# Create cache directory
RUN mkdir /srv/squid3
RUN chown proxy:proxy /srv/squid3

# Install run.sh
ADD bin/run.sh /usr/local/bin/run.sh
RUN chmod 755 /usr/local/bin/run.sh

EXPOSE 3128
CMD ["/usr/local/bin/run.sh"]
