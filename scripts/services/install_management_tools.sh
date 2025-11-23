#!/usr/bin/env bash
# Install Wazuh, Snort, and Suricata management scripts

set -euo pipefail

echo "[+] Installing CrocLinux management tools"

# Copy management scripts to /usr/local/bin
cp scripts/services/manage_wazuh.sh /usr/local/bin/croc-wazuh
cp scripts/services/manage_suricata.sh /usr/local/bin/croc-suricata
cp scripts/services/manage_snort.sh /usr/local/bin/croc-snort

# Make executable
chmod +x /usr/local/bin/croc-wazuh
chmod +x /usr/local/bin/croc-suricata
chmod +x /usr/local/bin/croc-snort

echo "[+] Management tools installed:"
echo "  - croc-wazuh (Wazuh Manager)"
echo "  - croc-suricata (Suricata IDS)"
echo "  - croc-snort (Snort IDS)"

