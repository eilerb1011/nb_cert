#!/bin/sh
token=
fqdn=
certbot certonly --manual --manual-auth-hook /etc/letsencrypt/acme-lindns-auth.py --preferred-challenges dns --debug-challenges -d $fqdn 
nb-cert.sh
