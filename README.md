# nb_cert
Cert updater for Nodebalancer
The script in the repo should replace your certbot renewal command in systemctl timers
The following variables should be set -

FQDN should equal the full hostname tied to your nodebalancer as requested in your certificate
NB_ID should equal the numeric value of your nodebalancer ID as you have already set up
TOKEN should equal a Linode Personal Access Token with R/W access to Nodebalancers

The script makes the following assumptions:
  You have created a Nodebalancer configuration using TLS Termination and have already created the backend nodes
  You are terminating TLS on the Nodebalancer
  You will use DNS based validation through Certbot
  Your systems are running Linux
  
