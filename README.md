# Ethereum Geth Full Node Deployment

A comprehensive guide for deploying an Ethereum execution client using Go Ethereum (Geth).

## Overview

This repository provides everything needed to run a full Ethereum node using Geth. Since The Merge, running an Ethereum node requires both an execution client (Geth) and a consensus client. This guide covers the execution layer setup.

## Requirements

- Ubuntu 22.04 LTS or Debian 12
- 8 CPU cores (16 recommended)
- 32GB RAM minimum
- 2TB NVMe SSD (fast storage is critical)
- 25+ Mbps internet connection
- Static IP or dynamic DNS

## Architecture

```
                    +------------------+
                    |   Consensus      |
                    |   Client         |
                    |   (Lighthouse/   |
                    |    Prysm/etc)    |
                    +--------+---------+
                             |
                    Engine API (8551)
                             |
                    +--------+---------+
                    |   Execution      |
                    |   Client         |
                    |   (Geth)         |
                    +------------------+
```

## Quick Start

```bash
git clone https://github.com/your-username/ethereum-geth-node.git
cd ethereum-geth-node
chmod +x scripts/install.sh
./scripts/install.sh
```

## Directory Structure

```
.
├── config/
│   └── geth-config.toml
├── scripts/
│   ├── install.sh
│   ├── start.sh
│   └── monitor.sh
├── docker/
│   └── docker-compose.yml
├── jwt/
│   └── README.md
└── docs/
    ├── consensus-setup.md
    └── troubleshooting.md
```

## Sync Modes

- **Snap sync** (default): Fastest, downloads state snapshots
- **Full sync**: Downloads all blocks and executes all transactions
- **Archive**: Full sync plus keeps all historical states

## Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 30303 | TCP/UDP | P2P networking |
| 8545 | TCP | HTTP RPC |
| 8546 | TCP | WebSocket RPC |
| 8551 | TCP | Engine API (consensus) |

## Security

- Never expose RPC ports to the internet without authentication
- Use JWT authentication for Engine API
- Run behind a firewall
- Keep system and Geth updated

## License

MIT License
