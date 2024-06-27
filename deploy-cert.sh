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
DIR=$PWD
chmod +x $DIR/deploy-cert.sh
chmod +x $DIR/nb-cert.sh
chmod +x $DIR/acme-lin-dns.py
chmod +x $DIR/post-install.sh
apt update && apt install -y certbot jq python3
mv $DIR/acme-lin-dns.py /etc/letsencrypt/
mv $DIR/nb-cert.sh /etc/letsencrypt/
certbot certonly --manual --manual-auth-hook /etc/letsencrypt/acme-lindns-auth.py --preferred-challenges dns -d $fqdn 
sleep 60
nb-cert.sh
post_install.sh
