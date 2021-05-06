#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir

CERTS_DIR='../certs'

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