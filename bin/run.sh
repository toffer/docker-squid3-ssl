#!/bin/sh

# Install cert
cp -v /etc/squid3/certs/*.crt /usr/share/ca-certificates/
find /etc/squid3/certs -name '*.crt'  -printf "%f\n" >> /etc/ca-certificates.conf
/usr/sbin/update-ca-certificates --fresh

# Prep cache directory
/usr/sbin/squid3 -z -N -f /etc/squid3/squid3-ssl.conf

# Run squid
/usr/sbin/squid3 -N -f /etc/squid3/squid3-ssl.conf
