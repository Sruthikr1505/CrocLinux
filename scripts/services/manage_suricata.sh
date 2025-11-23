#!/usr/bin/env bash
# Suricata Management Script for CrocLinux

set -euo pipefail

ACTION="${1:-status}"

case "$ACTION" in
  start)
    echo "[+] Starting Suricata IDS"
    sudo systemctl start suricata
    ;;
  stop)
    echo "[+] Stopping Suricata IDS"
    sudo systemctl stop suricata
    ;;
  restart)
    echo "[+] Restarting Suricata IDS"
    sudo systemctl restart suricata
    ;;
  reload)
    echo "[+] Reloading Suricata Rules"
    sudo suricatasc -c reload-rules
    ;;
  status)
    echo "[+] Suricata IDS Status"
    sudo systemctl status suricata --no-pager
    echo ""
    echo "[+] Suricata Statistics"
    sudo suricatasc -c stats || echo "Suricata control socket not available"
    ;;
  logs)
    echo "[+] Viewing Suricata Alerts (Press Ctrl+C to exit)"
    if command -v jq >/dev/null 2>&1; then
      sudo tail -f /var/log/suricata/eve.json | jq 'select(.event_type=="alert")'
    else
      sudo tail -f /var/log/suricata/eve.json
    fi
    ;;
  update-rules)
    echo "[+] Updating Suricata Rules"
    if command -v suricata-update >/dev/null 2>&1; then
      sudo suricata-update
      sudo suricatasc -c reload-rules
    else
      echo "[!] suricata-update not available"
    fi
    ;;
  test-config)
    echo "[+] Testing Suricata Configuration"
    sudo suricata -T -c /etc/suricata/suricata.yaml
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|reload|status|logs|update-rules|test-config}"
    exit 1
    ;;
esac

