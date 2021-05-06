#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir
source "../../.env" # load .env variables

CERTS_DIR='../certs'
DOMAIN=$(echo "$DOMAIN")

# 1. Clear out any pre-existing .pem or .cnf files
rm ./*.pem ./*.cnf ${CERTS_DIR}/*.pem ${CERTS_DIR}/*.cnf 2> /dev/null

# 2. Generate "dummy" Certificate Authority's private key and self-signed certificate
openssl req \
    -x509 \
    -newkey rsa:4096 \
    -days 3650 \
    -keyout ca-key.pem \
    -out ca-cert.pem \
    -nodes \
    -subj "/C=US/ST=Texas/L=Faketown/O=Local Dev CA/CN=*.localdevca.com/emailAddress=signer@localdevca.com"

# 3. Trust the newly CA signed cert
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "./ca-cert.pem"

# 4. Generate our site's private key and certificate signing request (CSR)
openssl req \
    -newkey rsa:4096 \
    -keyout "${DOMAIN}-key.pem" \
    -out "${DOMAIN}-req.pem" \
    -nodes \
    -subj "/CN=*.${DOMAIN}"

# 5. Create an extensions file for reference in step 4
echo "subjectAltName=DNS:*.${DOMAIN},IP:0.0.0.0" > san-ext.cnf

# 6. Use CA's private key to sign our site's CSR and get back the signed certificate
openssl x509 \
    -req -in "${DOMAIN}-req.pem" \
    -days 3650 \
    -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial \
    -out "${DOMAIN}-cert.pem" \
    -extfile san-ext.cnf

# 7. Move newly generated cert files to certs directory
mv -i ./*.pem ./*.cnf ${CERTS_DIR}/