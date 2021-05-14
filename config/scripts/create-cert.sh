#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir
source "../../.env" # load .env variables

CERTS_DIR='../certs'
DOMAIN="${1:-$DOMAIN}"

if [ -f "${CERTS_DIR}/${DOMAIN}-cert.pem" ]; then
    echo "Existing certificate found for ${DOMAIN}"
    exit 1
fi

# Generate our site's private key and certificate signing request (CSR)
openssl req \
    -newkey rsa:4096 \
    -sha256 \
    -nodes \
    -keyout "${DOMAIN}-key.pem" \
    -out "${DOMAIN}-req.pem" \
    -subj "/CN=*.${DOMAIN}"

# Create an extensions file for reference in the following x509 signing request
echo "subjectAltName=DNS:${DOMAIN}, DNS:www.${DOMAIN}, DNS:*.${DOMAIN}" > "${DOMAIN}-SAN.cnf"

# Use CA's private key to sign our site's CSR and get back the signed certificate
openssl x509 \
    -req \
    -sha256 \
    -CA "${CERTS_DIR}/CA-cert.pem" -CAkey "${CERTS_DIR}/CA-key.pem" \
    -CAcreateserial -CAserial "${CERTS_DIR}/CA-cert.srl" \
    -in "${DOMAIN}-req.pem" \
    -out "${DOMAIN}-cert.pem" \
    -days 365 \
    -extfile "${DOMAIN}-SAN.cnf"

# Move newly generated cert files to certs directory
mv -i ./*.pem ./*.cnf ./*.srl ${CERTS_DIR}/ 2> /dev/null