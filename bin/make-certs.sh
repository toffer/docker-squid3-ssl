#!/bin/sh

# Generate a private key and a self-signed certificate.

# Everything should stay in the same directory.
DIR=$(readlink -f $0 | xargs dirname)

# Use the simplified openssl.cnf config file in the same
# directory as this script, rather than editing the default
# one in /etc/ssl/.
CONFIG='openssl.cnf'

# Get domain name from config file.
# Domain is used to name self-signed cert file.
DOMAIN=$(grep commonName $DIR/$CONFIG | cut -d'=' -f 2 | tr -d ' ')

# Generate private key.
openssl genrsa -out $DIR/private.pem 1024

# Generate cert signing request.
openssl req -new \
    -key $DIR/private.pem \
    -out $DIR/proxy.csr \
    -config $DIR/$CONFIG

# Generate self-signed cert.
openssl x509 -req \
    -days 365 \
    -signkey $DIR/private.pem \
    -in $DIR/proxy.csr \
    -out $DIR/$DOMAIN.crt \
    -extensions v3_req \
    -extfile $DIR/$CONFIG

# Delete signing request.
rm $DIR/proxy.csr
