#!/bin/bash

MQTT_CONF="/etc/mosquitto/mosquitto.conf"

# Backup once
if [ ! -f "$MQTT_CONF.bak" ]; then
    sudo cp "$MQTT_CONF" "$MQTT_CONF.bak"
fi

# Define secure listener config block
SECURE_CONFIG="
# Smart Doorbell MQTT Secure Configuration
listener 8002
cafile /etc/mosquitto/certs/orion_ca.crt
keyfile /etc/mosquitto/certs/ring_server.key
certfile /etc/mosquitto/certs/ring_server.crt
"

# Check if secure config is already in mosquitto.conf
if grep -q "Smart Doorbell MQTT Secure Configuration" "$MQTT_CONF"; then
    echo "ℹ️ Secure MQTT config already exists in $MQTT_CONF"
else
    echo "🔧 Adding secure MQTT config to $MQTT_CONF"
    echo "$SECURE_CONFIG" | sudo tee -a "$MQTT_CONF" > /dev/null
    echo "✅ Secure configuration added."
fi

# Restart service
echo "🔄 Restarting Mosquitto..."
sudo systemctl restart mosquitto && echo "✅ Mosquitto restarted." || echo "❌ Restart failed."
