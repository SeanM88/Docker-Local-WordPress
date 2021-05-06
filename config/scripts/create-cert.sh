#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir
source "../../.env" # load .env variables

CERTS_DIR='../certs'
DOMAIN=$(echo "$DOMAIN")

# 1. Generate our site's private key and certificate signing request (CSR)
openssl req \
    -newkey rsa:4096 \
    -keyout "${DOMAIN}-key.pem" \
    -out "${DOMAIN}-req.pem" \
    -nodes \
    -subj "/CN=*.${DOMAIN}"

# 2. Create an extensions file for reference in step 4
echo "subjectAltName=DNS:*.${DOMAIN},IP:0.0.0.0" > subj-alt-name.cnf

# 3. Use CA's private key to sign our site's CSR and get back the signed certificate
openssl x509 \
    -req -in "${DOMAIN}-req.pem" \
    -days 3650 \
    -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial \
    -out "${DOMAIN}-cert.pem" \
    -extfile subj-alt-name.cnf

# 4. Move newly generated cert files to certs directory
mv -i ./*.pem ./*.cnf ${CERTS_DIR}/