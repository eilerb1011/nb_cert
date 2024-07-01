#!/bin/bash 
# Define the service file path 
SERVICE_FILE="/lib/systemd/system/certbot.service" 
# Check if the ExecStartPost entry already exists 
grep -q "ExecStartPost=/etc/nb-cert.sh" $SERVICE_FILE 
if [ $? -ne 0 ]; then 
  # Add ExecStartPost in the [Service] section 
  sed -i '/\[Service\]/a ExecStartPost=/etc/nb-cert.sh' $SERVICE_FILE 
# Reload the systemd daemon to apply changes 
  systemctl daemon-reload 
  echo "ExecStartPost=/etc/nb-cert.sh added to the [Service] section of $SERVICE_FILE" 
else 
  echo "ExecStartPost=/etc/nb-cert.sh already exists in $SERVICE_FILE" 
fi
