# Geth Troubleshooting Guide

## Common Issues

### Node Not Syncing

**Symptom**: Sync progress stuck or very slow

**Solutions**:
1. Ensure you have a consensus client running and connected
2. Check JWT authentication is working between clients
3. Verify network connectivity and firewall settings
4. Increase cache size if you have available RAM

```bash
# Check sync status
geth attach --exec "eth.syncing" /var/lib/geth/geth.ipc

# Check peer count
geth attach --exec "net.peerCount" /var/lib/geth/geth.ipc
```

### Engine API Connection Failed

**Symptom**: Consensus client cannot connect to Geth

**Solutions**:
1. Verify JWT secret is identical on both clients
2. Check authrpc settings in Geth config
3. Ensure port 8551 is accessible

```bash
# Test Engine API
curl -X POST -H "Content-Type: application/json" \
  --data '{"jsonrpc":"2.0","method":"engine_exchangeCapabilities","params":[[]],"id":1}' \
  http://localhost:8551
```

### Out of Memory

**Symptom**: Geth crashes with OOM errors

**Solutions**:
1. Reduce cache settings
2. Increase system swap
3. Close other memory-intensive applications
4. Consider using a machine with more RAM

### Database Corruption

**Symptom**: Geth fails to start with database errors

**Solutions**:
1. Stop Geth completely
2. Try running with --db.engine=pebble if using LevelDB
3. As last resort, remove chaindata and resync

```bash
sudo systemctl stop geth
rm -rf /var/lib/geth/geth/chaindata
sudo systemctl start geth
```

### High Disk I/O

**Symptom**: System becomes slow due to disk operations

**Solutions**:
1. Ensure you are using NVMe SSD
2. Increase cache to reduce disk writes
3. Consider enabling pruning
4. Check for other processes using disk

## Performance Tuning

### Recommended Settings for 32GB RAM

```toml
[Eth]
DatabaseCache = 8192
TrieCleanCache = 1024
TrieDirtyCache = 512
SnapshotCache = 512
```

### Recommended Settings for 16GB RAM

```toml
[Eth]
DatabaseCache = 4096
TrieCleanCache = 512
TrieDirtyCache = 256
SnapshotCache = 256
```

## Useful Commands

```bash
# View logs
sudo journalctl -u geth -f

# Check version
geth version

# Console access
geth attach /var/lib/geth/geth.ipc

# Get node info
geth attach --exec "admin.nodeInfo" /var/lib/geth/geth.ipc

# Add peer manually
geth attach --exec "admin.addPeer('enode://...')" /var/lib/geth/geth.ipc
```
