#!/bin/bash
#####################
#if https_config exists, update with new cert
#else if http exists, update to https
#if neither, exit
# Fully Qualified Domain Name (FQDN) ie www.mydomain.com - how it looks on your cert
FQDN=$fqdn

# Linode API details
TOKEN=$nb_token
NB_ID=$nb_id
api_base_url="https://api.linode.com/v4"
# JSON file to store SSL configuration
SSL_CONFIG_FILE="/tmp/ssl_config.json"
rm -rf $SSL_CONFIG_FILE
# Path to certbot renewal directory
CERTBOT_RENEWAL_DIR="/etc/letsencrypt/live/$FQDN"

CONFIG_ID=""
CONFIG_ID=$(curl "$api_base_url/nodebalancers/$NB_ID/configs" -H "Authorization: Bearer $TOKEN" | jq '.data[] | select (.protocol == "https") | .id')
if [[ -z "$CONFIG_ID" ]]; then
CONFIG_ID=$(curl -s -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" "$api_base_url/nodebalancers/$NB_ID/configs" | jq -r '.data[] | select(.protocol == "http") | .id')
if [[ -z "$CONFIG_ID" ]]; then
    echo "No Nodebalancer Configs exist"
    exit 1
fi
fi
# Check if cert and key files exist
if [ ! -f "$CERTBOT_RENEWAL_DIR/fullchain.pem" ] || [ ! -f "$CERTBOT_RENEWAL_DIR/privkey.pem" ]; then
    echo "Error: Certbot renewal files not found."
    exit 1
fi

# Function to extract base64 encoded cert or key from single-line PEM
extract_base64_from_pem() {
    local pem_file="$1"
    awk '/-----BEGIN .*-----/{flag=1; next} /-----END .*-----/{flag=0} flag' "$pem_file" | tr -d '\n'
}

# Extract base64 encoded cert and key
SSL_CERT=$(extract_base64_from_pem "$CERTBOT_RENEWAL_DIR/cert.pem")
SSL_KEY=$(extract_base64_from_pem "$CERTBOT_RENEWAL_DIR/privkey.pem")

# Create JSON object with \n added
SSL_JSON=$(cat <<EOF
{
  "protocol": "https",
  "port": 443,
  "ssl_cert": "-----BEGIN CERTIFICATE-----\n$SSL_CERT\n-----END CERTIFICATE-----",
  "ssl_key": "-----BEGIN PRIVATE KEY-----\n$SSL_KEY\n-----END PRIVATE KEY-----"
}
EOF
)

# Output SSL config to JSON file
echo "$SSL_JSON" > "$SSL_CONFIG_FILE"

# Update Linode API with new SSL configuration
curl -X PUT "$api_base_url/nodebalancers/$NB_ID/configs/$CONFIG_ID" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" \
-d @"$SSL_CONFIG_FILE"
#
echo "SSL configuration updated successfully."
