#!/usr/bin/env bash
# Snort Management Script for CrocLinux

set -euo pipefail

ACTION="${1:-status}"
INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
INTERFACE=${INTERFACE:-eth0}

case "$ACTION" in
  start)
    echo "[+] Starting Snort IDS on interface $INTERFACE"
    sudo systemctl start snort
    ;;
  stop)
    echo "[+] Stopping Snort IDS"
    sudo systemctl stop snort
    ;;
  restart)
    echo "[+] Restarting Snort IDS"
    sudo systemctl restart snort
    ;;
  status)
    echo "[+] Snort IDS Status"
    sudo systemctl status snort --no-pager
    echo ""
    echo "[+] Snort Interface: $INTERFACE"
    ;;
  logs)
    echo "[+] Viewing Snort Alerts (Press Ctrl+C to exit)"
    if [[ -f /var/log/snort/alert ]]; then
      sudo tail -f /var/log/snort/alert
    else
      echo "[!] Snort alert log not found. Check /var/log/snort/"
    fi
    ;;
  test-config)
    echo "[+] Testing Snort Configuration"
    sudo snort -T -c /etc/snort/snort.conf -i "$INTERFACE"
    ;;
  update-rules)
    echo "[+] Updating Snort Rules"
    if [[ -d /etc/snort/rules ]]; then
      echo "[+] Snort rules directory: /etc/snort/rules"
      echo "[+] To update rules, edit /etc/snort/snort.conf"
      echo "[+] Or download from: https://www.snort.org/downloads"
    fi
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|status|logs|test-config|update-rules}"
    exit 1
    ;;
esac

