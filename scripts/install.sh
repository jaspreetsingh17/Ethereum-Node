#!/bin/bash

# Ethereum Geth Installation Script
# Tested on Ubuntu 22.04 LTS

set -e

GETH_VERSION="1.13.14"
DATA_DIR="/var/lib/geth"
JWT_DIR="/var/lib/ethereum/jwt"

echo "Installing Ethereum Geth ${GETH_VERSION}..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y software-properties-common curl wget

# Add Ethereum PPA
sudo add-apt-repository -y ppa:ethereum/ethereum

# Install Geth
sudo apt update
sudo apt install -y geth

# Alternatively, download specific version
# wget https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-${GETH_VERSION}.tar.gz
# tar -xzf geth-linux-amd64-${GETH_VERSION}.tar.gz
# sudo mv geth-linux-amd64-${GETH_VERSION}/geth /usr/local/bin/

# Create geth user
if ! id "geth" &>/dev/null; then
    sudo useradd -r -m -s /bin/bash geth
fi

# Create directories
sudo mkdir -p ${DATA_DIR}
sudo mkdir -p ${JWT_DIR}
sudo chown -R geth:geth ${DATA_DIR}
sudo chown -R geth:geth /var/lib/ethereum

# Generate JWT secret for consensus client communication
openssl rand -hex 32 | sudo tee ${JWT_DIR}/jwt.hex > /dev/null
sudo chmod 600 ${JWT_DIR}/jwt.hex
sudo chown geth:geth ${JWT_DIR}/jwt.hex

# Copy configuration
sudo mkdir -p /etc/geth
sudo cp ../config/geth-config.toml /etc/geth/
sudo chown -R geth:geth /etc/geth

# Install systemd service
sudo cp ../systemd/geth.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable geth

# Configure firewall
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp

echo ""
echo "Installation complete!"
echo "JWT secret location: ${JWT_DIR}/jwt.hex"
echo ""
echo "IMPORTANT: You also need a consensus client (Lighthouse, Prysm, etc.)"
echo "Share the JWT secret with your consensus client"
echo ""
echo "Start Geth with: sudo systemctl start geth"
