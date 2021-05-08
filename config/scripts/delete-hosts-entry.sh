#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir
source "../../.env" # load .env variables

HOSTNAME="${1:-$DOMAIN}"
IP="${2:-$IP}"

if [[ "$HOSTNAME" =~ (localhost|broadcasthost) ]]; then
  echo "DENIED: deleting ${HOSTNAME} entry forbidden!"
  exit 1
fi

if [ -n "$(egrep -w "(\b|\S)${HOSTNAME}(\b|\S)" /etc/hosts)" ]; then
  echo "Entry for ${HOSTNAME} found in /etc/hosts file. Removing now...";
  sudo sed -i".bak" "/${HOSTNAME}/d" /etc/hosts
  echo "Entry for ${HOSTNAME} removed successfully!"
else
  echo "${HOSTNAME} was not found in your /etc/hosts file.";
fi