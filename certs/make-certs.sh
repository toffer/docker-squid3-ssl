#!/bin/sh

# Generate a private key and a self-signed certificate.

# Use the simplified openssl.cnf config file in the current
# directory, rather than editing the default one in /etc/ssl/.
CWD=`pwd`
CONFIG="$CWD/openssl.cnf"

# Get domain name from config file
# Domain is used to name self-signed cert file
DOMAIN=$(grep commonName $CONFIG | cut -d'=' -f 2 | tr -d ' ')

# Generate private key
openssl genrsa -out private.key 1024

# Generate cert signing request
openssl req -new \
    -key private.key \
    -out proxy.csr \
    -config $CONFIG

# Generate self-signed cert
openssl x509 -req \
    -days 365 \
    -signkey private.key \
    -in proxy.csr \
    -out $DOMAIN.crt \
    -extensions v3_req \
    -extfile $CONFIG

# Delete signing request
rm proxy.csr
