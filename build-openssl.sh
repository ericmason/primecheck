#!/bin/bash

apt-get -y build-dep openssl
cd /usr/src
apt-get source openssl

openssl_dir=`find . -maxdepth 1 -type d -name openssl-\*`
cd $openssl_dir

# Add --enable-ssl-trace
# sed -Ei 's/^CONFARGS  = /CONFARGS  = --enable-ssl-trace /' debian/rules
sed -Ei '/^CONFARGS/ s/$/ enable-ssl-trace/' debian/rules

# Build the package
debuild -b -uc -us
