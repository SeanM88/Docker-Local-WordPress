#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir

CERTS_DIR='../certs'

# Generate "dummy" Certificate Authority's private key and self-signed certificate
openssl req \
    -x509 \
    -sha256 \
    -nodes \
    -newkey rsa:4096 \
    -keyout CA-key.pem \
    -out CA-cert.pem \
    -days 3650 \
    -subj "/C=US/ST=Texas/L=Faketown/O=Docker Local WordPress/CN=Docker Local WordPress CA/emailAddress=certs@dlwpca.com"

# Move newly generated CA files to certs directory
mv -i ./*.pem ${CERTS_DIR}/

# Trust the newly CA signed cert
sudo security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "${CERTS_DIR}/CA-cert.pem"


# if [ -z "$(security find-certificate -a -e 'certs@dlwpca.com' '/Library/Keychains/System.keychain')" ]; then
#     echo "Cert not found"
# else
#     echo "Cert found"
# fi