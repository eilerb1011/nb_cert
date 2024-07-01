# deploy-cert.sh
Cert deployment and updater for Nodebalancer - place in /etc
The script in the repo should be added to your certbot renewal service in systemctl using the post_install.sh
The following variables should be set -
- FQDN should equal the full hostname tied to your nodebalancer as requested in your certificate
- NB_ID should equal the numeric value of your nodebalancer ID as you have already set up
- nb_token should equal a Linode Personal Access Token with R/W access to Nodebalancers
- dns_token should equal a Linode Personal Access Token with R/W access to DNS

The script makes the following assumptions:
  - You have created a Nodebalancer configuration using TLS Termination and have already created the backend nodes
  - Or you have created an HTTP configuration and are ok with changing that to HTTPS only
  - You are terminating or want to terminate TLS on the Nodebalancer
  - You will use Linode DNS based validation through Certbot
  - Your systems are running Linux
  - You have a dns name tied to your Nodebalancer
  
Read this medium article for further details:
