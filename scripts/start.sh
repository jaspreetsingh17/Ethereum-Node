#!/bin/bash

# Start Geth Node

set -e

DATA_DIR="/var/lib/geth"
JWT_SECRET="/var/lib/ethereum/jwt/jwt.hex"
CONFIG_FILE="/etc/geth/geth-config.toml"

echo "Starting Geth node..."

# Check if consensus client JWT exists
if [ ! -f "${JWT_SECRET}" ]; then
    echo "ERROR: JWT secret not found at ${JWT_SECRET}"
    echo "Generate with: openssl rand -hex 32 > ${JWT_SECRET}"
    exit 1
fi

# Start via systemd
sudo systemctl start geth

# Wait for startup
sleep 10

# Check status
if systemctl is-active --quiet geth; then
    echo "Geth started successfully"
    echo ""
    echo "Sync status:"
    geth attach --exec "eth.syncing" ${DATA_DIR}/geth.ipc
    echo ""
    echo "Peer count:"
    geth attach --exec "net.peerCount" ${DATA_DIR}/geth.ipc
else
    echo "Failed to start Geth"
    sudo journalctl -u geth --no-pager -n 50
    exit 1
fi
