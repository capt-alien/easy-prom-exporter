#!/bin/bash

SERVICE_NAME=easy-prom-exporter
BINARY_PATH=/usr/local/bin/$SERVICE_NAME
SERVICE_FILE=/etc/systemd/system/$SERVICE_NAME.service

echo "[!] Stopping and disabling $SERVICE_NAME..."
sudo systemctl stop $SERVICE_NAME
sudo systemctl disable $SERVICE_NAME

echo "[!] Removing systemd unit..."
sudo rm -f $SERVICE_FILE
sudo systemctl daemon-reload

# Prompt for binary removal
read -p "Delete $BINARY_PATH as well? [y/N]: " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "[!] Removing binary..."
    sudo rm -f $BINARY_PATH
else
    echo "[=] Skipping binary removal."
fi

echo "[✓] $SERVICE_NAME fully uninstalled."
