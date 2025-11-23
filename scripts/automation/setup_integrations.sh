#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="/var/log/croc-linux-automation.log"
exec > >(tee -a "$LOG_FILE") 2>&1

MISP_URL="https://misp.local"
MISP_KEY="CHANGE_ME"
WAZUH_API="https://127.0.0.1:55000"
WAZUH_USER="wazuh"
WAZUH_PASS="CHANGE_ME"

function configure_filebeat() {
  echo "[+] Configuring Filebeat to forward logs into Elasticsearch"
  cat <<'EOF_FBEAT' > /etc/filebeat/filebeat.yml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/ossec/logs/alerts/alerts.json

output.elasticsearch:
  hosts: ["https://127.0.0.1:9200"]
  protocol: "https"
  username: "elastic"
  password: "CHANGEME"
  ssl.verification_mode: none

setup.kibana:
  host: "https://127.0.0.1:5601"
  ssl.verification_mode: none

processors:
  - decode_json_fields:
      fields: ["message"]
      target: "json"
      overwrite_keys: true
EOF_FBEAT
  systemctl restart filebeat
}

function integrate_misp_wazuh() {
  echo "[+] Enabling MISP to Wazuh threat intelligence automation"
  local script_path="/usr/local/bin/croc-misp-to-wazuh.py"
  cat <<'EOF_PY' > "$script_path"
#!/usr/bin/env python3
import json
import os
import requests

MISP_URL = os.environ.get("MISP_URL", "https://misp.local")
MISP_KEY = os.environ.get("MISP_KEY")
WAZUH_API = os.environ.get("WAZUH_API", "https://127.0.0.1:55000")
WAZUH_USER = os.environ.get("WAZUH_USER", "wazuh")
WAZUH_PASS = os.environ.get("WAZUH_PASS")

session = requests.Session()
session.verify = False
session.headers.update({"Authorization": MISP_KEY, "Accept": "application/json", "Content-Type": "application/json"})

events = session.get(f"{MISP_URL}/events/restSearch", timeout=30).json()
indicators = set()
for event in events.get("response", []):
    for attribute in event.get("Attribute", []):
        value = attribute.get("value")
        if value:
            indicators.add(value)

wazuh_session = requests.Session()
wazuh_session.verify = False
wazuh_session.auth = (WAZUH_USER, WAZUH_PASS)

payload = {"items": [{"indicator": indicator, "type": "auto", "source": "MISP"} for indicator in indicators]}
wazuh_session.post(f"{WAZUH_API}/mitre/indicators", json=payload, timeout=30)
print(json.dumps({"synced": len(indicators)}))
EOF_PY
  chmod +x "$script_path"

  cat <<'EOF_SERVICE' > /etc/systemd/system/croc-misp-sync.service
[Unit]
Description=CrocLinux MISP to Wazuh IOC Sync
After=network-online.target

[Service]
Environment="MISP_URL=https://misp.local"
Environment="MISP_KEY=CHANGE_ME"
Environment="WAZUH_API=https://127.0.0.1:55000"
Environment="WAZUH_USER=wazuh"
Environment="WAZUH_PASS=CHANGE_ME"
ExecStart=/usr/local/bin/croc-misp-to-wazuh.py
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF_SERVICE

  cat <<'EOF_TIMER' > /etc/systemd/system/croc-misp-sync.timer
[Unit]
Description=Periodic MISP to Wazuh IOC sync

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF_TIMER

  systemctl daemon-reload
  systemctl enable --now croc-misp-sync.timer
}

function deploy_threat_dashboard() {
  echo "[+] Importing CrocSec threat correlation Kibana objects"
  local dashboard_json="/usr/share/croc-linux/threat-dashboard.ndjson"
  mkdir -p /usr/share/croc-linux
  cat <<'EOF_DASH' > "$dashboard_json"
{"type":"dashboard","id":"croc-threat-correlation","attributes":{"title":"CrocSec Threat Correlation","description":"Unified SOC view for CrocLinux","panelsJSON":"[]","timeRestore":true,"timeTo":"now","timeFrom":"now-1h","version":1,"kibanaSavedObjectMeta":{"searchSourceJSON":"{\"query\":{\"language\":\"kuery\",\"query\":\"json.rule.level >= 6\"},\"filter\":[]}"}},"references":[]}
EOF_DASH

  curl -k -u elastic:CHANGEME -X POST "https://127.0.0.1:5601/api/saved_objects/_import?overwrite=true" \
    -H "kbn-xsrf: true" \
    --form file=@"$dashboard_json"
}

function install_crocsec_cli() {
  echo "[+] Installing CrocSec CLI assistant"
  local cli_path="/usr/local/bin/crocsec"
  cat <<'EOF_CLI' > "$cli_path"
#!/usr/bin/env python3
import argparse
import subprocess
import textwrap

RESPONSES = {
    "summary": "CrocSec monitors Wazuh, Suricata, Velociraptor, GRR, and TheHive with automated enrichment via MISP.",
    "status": "systemctl --type=service | grep -E 'wazuh|suricata|thehive|cortex|velociraptor'",
    "update_rules": "/usr/local/sbin/croc-update-rules",
    "investigate": "sudo wazuh-logtest --event"
}

def run_command(cmd):
    if cmd not in RESPONSES:
        print("Unknown intent. Try: summary, status, update_rules, investigate")
        return
    action = RESPONSES[cmd]
    if action.startswith("systemctl"):
        subprocess.run(action, shell=True, check=False)
    elif action.startswith("sudo") or action.startswith("/usr"):
        print(f"Suggested command: {action}")
    else:
        print(textwrap.fill(action, width=80))


def main():
    parser = argparse.ArgumentParser(description="CrocSec command helper")
    parser.add_argument("intent", help="summary|status|update_rules|investigate")
    args = parser.parse_args()
    run_command(args.intent)


if __name__ == "__main__":
    main()
EOF_CLI
  chmod +x "$cli_path"
}

function rule_update_scripts() {
  echo "[+] Creating rule update and IOC ingestion helpers"
  cat <<'EOF_RULES' > /usr/local/sbin/croc-update-rules
#!/usr/bin/env bash
set -euo pipefail

echo "[+] Updating Sigma rules"
cd /var/ossec/ruleset/sigma/repo
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git pull --ff-only
fi
sigma-cli convert -t wazuh -r ./rules -o ../generated
systemctl restart wazuh-manager

echo "[+] Updating YARA rules"
cd /var/ossec/ruleset/yara/community
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git pull --ff-only
fi
systemctl restart wazuh-manager
EOF_RULES
  chmod +x /usr/local/sbin/croc-update-rules

  cat <<'EOF_IOC' > /usr/local/sbin/croc-ioc-import
#!/usr/bin/env bash
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <ioc_file.json>"
  exit 1
fi
curl -k -X POST "$MISP_URL/events/add" -H "Authorization: $MISP_KEY" -H "Content-Type: application/json" -d @"$1"
EOF_IOC
  chmod +x /usr/local/sbin/croc-ioc-import
}

configure_filebeat
integrate_misp_wazuh
deploy_threat_dashboard
install_crocsec_cli
rule_update_scripts

echo "[+] CrocLinux automation stack configured"
