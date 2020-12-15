#!/bin/sh

export CERT_HASH=`openssl s_client -connect $HOST:$PORT < /dev/null 2>/dev/null | openssl x509 -fingerprint -sha256 -noout -in /dev/stdin | tr -d ':' | cut -d '=' -f 2 | tr A-Z a-z`

openfortivpn $HOST:$PORT -u $USER -p $PASS --persistent=$INTERVAL --trusted-cert $CERT_HASH -v | sed -u 's/DEBUG:  ip route add/INFO:   ip route add/; s/DEBUG:  Adding "nameserver/INFO:   Adding "nameserver/' | grep -v --line-buffered -e '^DEBUG'