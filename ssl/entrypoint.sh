#!/bin/bash
set -e

# Bash shell script for generating self-signed certs. Run this in a folder, as it
# generates a few files. Large portions of this script were taken from the
# following artcile:
#
# http://usrportage.de/archives/919-Batch-generating-SSL-certificates.html
#
# Additional alterations by: Brad Landers
# Date: 2012-01-27

# Script accepts a single argument, the fqdn for the cert
#DOMAIN="$1"

DOMAIN="stealthbox"

if [[ ! -f /etc/stealthbox/ssl/$DOMAIN.key || ! -f /etc/stealthbox/ssl/$DOMAIN.crt ]]; then
  echo "*** SSL Certificates missing from /etc/stealthbox/ssl. Creating them ..."

  mkdir -p /etc/stealthbox/ssl
  cd /etc/stealthbox/ssl

  rm -f /etc/stealthbox/ssl/$DOMAIN.*

  if [ -z "$DOMAIN" ]; then
    echo "Usage: $(basename $0) <domain>"
    exit 11
  fi

  fail_if_error() {
    if [ $? -ne 0 ]; then
      unset PASSPHRASE
      echo "An error has occured while generating SSL Certificate: $1"
      exit 10
    fi
  }

  # Generate a passphrase
  export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)

  # Certificate details; replace items in angle brackets with your own info
  subj="/O=$DOMAIN"

  # Generate the server private key
  openssl genrsa -des3 -out $DOMAIN.key -passout env:PASSPHRASE 2048
  #fail_if_error $?

  # Generate the CSR
  openssl req \
      -new \
      -batch \
      -subj "$(echo -n "$subj" | tr "\n" "/")" \
      -key $DOMAIN.key \
      -out $DOMAIN.csr \
      -passin env:PASSPHRASE
  fail_if_error $?
  cp $DOMAIN.key $DOMAIN.key.org
  fail_if_error $?

  # Strip the password so we don't have to type it every time we restart Apache
  openssl rsa -in $DOMAIN.key.org -out $DOMAIN.key -passin env:PASSPHRASE
  fail_if_error $?

  # Generate the cert (good for 10 years)
  openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
  fail_if_error $?

  chmod 400 /etc/stealthbox/ssl/$DOMAIN.key
else
  echo "SSL Certificate are available in /etc/stealthbox/ssl."
fi

exec "$@"
