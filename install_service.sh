#!/bin/bash

SERVICE_NAME=easy-prom-exporter
BINARY_PATH=/usr/local/bin/$SERVICE_NAME
SERVICE_FILE=/etc/systemd/system/$SERVICE_NAME.service

echo "[+] Installing $SERVICE_NAME..."

# Copy binary to /usr/local/bin
if [ ! -f "$BINARY_PATH" ]; then
    echo "[+] Moving binary to $BINARY_PATH"
    sudo cp ./easy-prom-exporter "$BINARY_PATH"
    sudo chmod +x "$BINARY_PATH"
else
    echo "[=] Binary already exists at $BINARY_PATH"
fi

# Create systemd service file
echo "[+] Writing systemd unit to $SERVICE_FILE"
sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=Easy Prometheus Exporter for Vikunja PVC
After=network.target

[Service]
ExecStart=$BINARY_PATH
Restart=on-failure
User=$(whoami)
WorkingDirectory=$(pwd)

[Install]
WantedBy=multi-user.target
EOF

# Reload, enable, and start the service
echo "[+] Enabling and starting $SERVICE_NAME..."
sudo systemctl daemon-reload
sudo systemctl enable --now $SERVICE_NAME

# Confirm it's running
echo "[+] Status:"
sudo systemctl status $SERVICE_NAME --no-pager

echo "[✓] Done. Metrics should now be available on :2112"
