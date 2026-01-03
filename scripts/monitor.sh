#!/bin/bash

# Geth Monitoring Script

DATA_DIR="/var/lib/geth"
IPC_PATH="${DATA_DIR}/geth.ipc"

while true; do
    clear
    echo "=========================================="
    echo "       Geth Node Monitor"
    echo "=========================================="
    echo ""
    
    # Check if Geth is running
    if ! systemctl is-active --quiet geth; then
        echo "WARNING: Geth is not running!"
        echo ""
        sleep 5
        continue
    fi
    
    # Sync status
    echo "Sync Status:"
    SYNC_STATUS=$(geth attach --exec "eth.syncing" ${IPC_PATH} 2>/dev/null)
    if [ "$SYNC_STATUS" == "false" ]; then
        echo "  Fully synced"
        BLOCK=$(geth attach --exec "eth.blockNumber" ${IPC_PATH} 2>/dev/null)
        echo "  Current block: ${BLOCK}"
    else
        echo "$SYNC_STATUS" | head -10
    fi
    echo ""
    
    # Peer info
    echo "Network:"
    PEERS=$(geth attach --exec "net.peerCount" ${IPC_PATH} 2>/dev/null)
    echo "  Connected peers: ${PEERS}"
    echo ""
    
    # System resources
    echo "System Resources:"
    GETH_PID=$(pgrep -x geth)
    if [ -n "$GETH_PID" ]; then
        ps -p $GETH_PID -o %cpu,%mem,rss --no-headers | while read cpu mem rss; do
            echo "  CPU: ${cpu}%"
            echo "  Memory: ${mem}%"
            echo "  RSS: $((rss/1024)) MB"
        done
    fi
    echo ""
    
    # Disk usage
    echo "Disk Usage:"
    du -sh ${DATA_DIR} 2>/dev/null | awk '{print "  Data directory: " $1}'
    df -h ${DATA_DIR} | tail -1 | awk '{print "  Disk free: " $4}'
    echo ""
    
    echo "Last updated: $(date)"
    echo "Press Ctrl+C to exit"
    
    sleep 30
done
