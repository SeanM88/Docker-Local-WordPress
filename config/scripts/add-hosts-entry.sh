#!/bin/bash

set -eu # exit on error & treat unset variables as errors
cd $(dirname "$0") # ensure script commands run from /scripts dir
source "../../.env" # load .env variables

HOSTNAME="${1:-$DOMAIN}"
IP="${2:-$IP}"

if [ -n "$(egrep -w "(\b|\S)${HOSTNAME}(\b|\S)" /etc/hosts)" ]; then
  echo "$HOSTNAME already exists:";
  echo $(egrep -w "(\b|\S)${HOSTNAME}(\b|\S)" /etc/hosts);
else
  echo "Adding $HOSTNAME to your /etc/hosts";
  printf "%s\t%s\n" "$IP" "$HOSTNAME" | sudo tee -a /etc/hosts > /dev/null;

  if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
    then
      echo "$HOSTNAME was added succesfully:";
      echo $(grep $HOSTNAME /etc/hosts);
    else
      echo "Failed to add $HOSTNAME to /etc/hosts file! Try again!";
  fi
fi