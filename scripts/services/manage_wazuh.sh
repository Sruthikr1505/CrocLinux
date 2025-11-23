#!/usr/bin/env bash
# Wazuh Management Script for CrocLinux

set -euo pipefail

WAZUH_BIN="/var/ossec/bin/wazuh-control"
ACTION="${1:-status}"

case "$ACTION" in
  start)
    echo "[+] Starting Wazuh Manager"
    sudo systemctl start wazuh-manager
    sudo "$WAZUH_BIN" start
    ;;
  stop)
    echo "[+] Stopping Wazuh Manager"
    sudo "$WAZUH_BIN" stop
    sudo systemctl stop wazuh-manager
    ;;
  restart)
    echo "[+] Restarting Wazuh Manager"
    sudo "$WAZUH_BIN" restart
    sudo systemctl restart wazuh-manager
    ;;
  status)
    echo "[+] Wazuh Manager Status"
    sudo systemctl status wazuh-manager --no-pager
    echo ""
    echo "[+] Wazuh Control Status"
    sudo "$WAZUH_BIN" status
    ;;
  logs)
    echo "[+] Viewing Wazuh Alerts (Press Ctrl+C to exit)"
    sudo tail -f /var/ossec/logs/alerts/alerts.json | jq .
    ;;
  test)
    echo "[+] Testing Wazuh Configuration"
    sudo "$WAZUH_BIN" testconfig
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|logs|test}"
    exit 1
    ;;
esac

