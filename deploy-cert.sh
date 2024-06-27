#!/bin/sh
###Put your token with DNS read/write here
dns_token=
#####Place your host fqdn here####
fqdn=
#####Fill in your token with Nodebalancer Read Write here#####
nb_token= 
####Fill in your Nodebalancer ID here####
nb_id=
export dns_token
export fqdn
export nb_token
export nb_id
cd /tmp
git clone https://github.com/eilerb1011/nb_cert
chmod +x /tmp/nb_cert/deploy-cert.sh
chmod +x /tmp/nb_cert/nb-cert.sh
chmod +x /tmp/nb_cert/acme-lin-dns.py
apt update && apt install -y certbot jq python3
mv /tmp/nb_cert/acme-lin-dns.py /etc/letsencrypt/
mv /tmp/nb_cert/nb-cert.sh /etc/letsencrypt/
certbot certonly --manual --manual-auth-hook /etc/letsencrypt/acme-lindns-auth.py --preferred-challenges dns -d $fqdn 
nb-cert.sh
