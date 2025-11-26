#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="/var/log/croc-linux-services.log"
exec > >(tee -a "$LOG_FILE") 2>&1

APT_OPTS=("-y" "-o" "Dpkg::Use-Pty=0")

function install_wazuh() {
  echo "[+] Installing Wazuh Manager and Elastic Stack"
  curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/wazuh-archive-keyring.gpg] https://packages.wazuh.com/4.x/apt stable main" > /etc/apt/sources.list.d/wazuh.list

  curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elastic-archive-keyring.gpg
  cat <<'EOF' > /etc/apt/sources.list.d/elastic-8.x.list
deb [signed-by=/usr/share/keyrings/elastic-archive-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main
EOF

  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install "${APT_OPTS[@]}" wazuh-manager filebeat elasticsearch kibana

  systemctl enable wazuh-manager
  systemctl enable elasticsearch
  systemctl enable kibana
  systemctl enable filebeat
}

function configure_wazuh() {
  echo "[+] Configuring Wazuh with CrocLinux defaults"
  cat <<'EOF' > /var/ossec/etc/ossec.conf
<ossec_config>
  <global>
    <jsonout_output>yes</jsonout_output>
    <email_notification>no</email_notification>
    <logall>no</logall>
    <logall_json>yes</logall_json>
  </global>
  <alerts>
    <log_alert_level>3</log_alert_level>
  </alerts>
  <remote>
    <connection>secure</connection>
    <port>1514</port>
  </remote>
  <ruleset>
    <decoder_dir>ruleset/decoders</decoder_dir>
    <rule_dir>ruleset/rules</rule_dir>
    <list>etc/lists/audit-keys</list>
    <list>etc/lists/mitre-attack</list>
    <list>etc/lists/yara-rules</list>
  </ruleset>
</ossec_config>
EOF
}

function install_misp() {
  echo "[+] Installing MISP"
  apt-get install "${APT_OPTS[@]}" misp
  systemctl enable misp-workers
  systemctl enable redis-server
  systemctl enable mariadb
}

function install_thehive_cortex() {
  echo "[+] Installing TheHive and Cortex"
  curl -fsSL https://deb.thehive-project.org/thehive-project.gpg.key | gpg --dearmor -o /usr/share/keyrings/thehive-archive.gpg
  echo "deb [signed-by=/usr/share/keyrings/thehive-archive.gpg] https://deb.thehive-project.org release main" > /etc/apt/sources.list.d/thehive-project.list
  apt-get update
  apt-get install "${APT_OPTS[@]}" thehive cortex
  systemctl enable thehive
  systemctl enable cortex
}

function install_velociraptor() {
  echo "[+] Installing Velociraptor"
  curl -L https://github.com/Velocidex/velociraptor/releases/latest/download/velociraptor-v0.7.1-linux-amd64 -o /usr/local/bin/velociraptor
  chmod +x /usr/local/bin/velociraptor
  useradd --system --home /var/lib/velociraptor --shell /usr/sbin/nologin velociraptor || true
  mkdir -p /etc/velociraptor /var/lib/velociraptor
  velociraptor config generate -i --role server --output /etc/velociraptor/server.config.yaml
  cat <<'EOF' > /etc/systemd/system/velociraptor.service
[Unit]
Description=Velociraptor server
After=network.target

[Service]
User=velociraptor
Group=velociraptor
ExecStart=/usr/local/bin/velociraptor --config /etc/velociraptor/server.config.yaml frontend -v
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl enable velociraptor
}

function install_forensics() {
  echo "[+] Installing forensics and memory analysis tools"
  apt-get install "${APT_OPTS[@]}" autopsy sleuthkit volatility3 volatility-tools bulk-extractor
}

function install_grr() {
  echo "[+] Installing GRR Rapid Response components"
  curl -fsSL https://storage.googleapis.com/releases.grr-response.com/grr-repo.gpg | gpg --dearmor -o /usr/share/keyrings/grr-archive.gpg
  echo "deb [signed-by=/usr/share/keyrings/grr-archive.gpg] https://storage.googleapis.com/releases.grr-response.com/deb stable main" > /etc/apt/sources.list.d/grr.list
  apt-get update
  apt-get install "${APT_OPTS[@]}" grr-server
  systemctl enable grr-server
}

function install_detection_rules() {
  echo "[+] Installing YARA, Sigma, OSQuery, Sysmon, Suricata, Snort"
  apt-get install "${APT_OPTS[@]}" yara yara-doc yara-tools sigma python3-sigma osquery suricata snort snort-rules-default sysmonforlinux

  systemctl enable suricata
  systemctl enable osqueryd
}

function configure_suricata() {
  echo "[+] Applying CrocLinux Suricata tuning"
  mkdir -p /etc/suricata/rules /var/log/suricata /var/run/suricata
  
  cat <<'EOF' > /etc/suricata/suricata.yaml
%YAML 1.1
---
default-log-level: info
default-rule-path: /etc/suricata/rules
rule-files:
  - suricata.rules
  - local.rules

af-packet:
  - interface: eth0
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
    threads: auto

outputs:
  - eve-log:
      enabled: yes
      filetype: regular
      filename: /var/log/suricata/eve.json
      types:
        - alert
        - http
        - dns
        - tls
        - ssh
        - flow
        - fileinfo
        - stats
      rotate-interval: 24h
      rotate-command: /usr/bin/suricatasc -c reload-rules

  - file-log:
      enabled: yes
      filename: /var/log/suricata/suricata.log
      append: yes

logging:
  default-log-format: "[%i] <%d> -- "
  outputs:
    - console:
        enabled: yes
EOF

  # Create local rules file
  cat <<'EOF' > /etc/suricata/rules/local.rules
# CrocLinux Local Suricata Rules
# Add custom rules here

# Example: Alert on suspicious HTTP requests
alert http any any -> any any (msg:"Suspicious HTTP Request"; content:"/etc/passwd"; sid:1000001; rev:1;)
EOF

  # Download community rules
  if command -v suricata-update >/dev/null 2>&1; then
    echo "[+] Updating Suricata rules"
    suricata-update || echo "[!] Suricata-update not available, skipping rule update"
  fi

  systemctl enable suricata
}

function configure_snort() {
  echo "[+] Configuring Snort IDS for CrocLinux"
  mkdir -p /etc/snort/rules /var/log/snort /var/run/snort
  
  # Get network interface
  INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n1)
  INTERFACE=${INTERFACE:-eth0}
  
  cat <<EOF > /etc/snort/snort.conf
# CrocLinux Snort Configuration
# Network interface
config interface: $INTERFACE

# Network variables
ipvar HOME_NET [192.168.0.0/16,10.0.0.0/8,172.16.0.0/12]
ipvar EXTERNAL_NET !\$HOME_NET
portvar HTTP_PORTS [80,443,8080,8443]
portvar SHELLCODE_PORTS !80
portvar ORACLE_PORTS 1521

# Include rules
include \$RULE_PATH/local.rules
include \$RULE_PATH/snort.rules

# Output plugins
output alert_syslog: LOG_AUTH LOG_ALERT
output log_tcpdump: snort.log
output database: log, mysql, user=snort password=snort dbname=snort host=localhost
EOF

  # Create local rules
  cat <<'EOF' > /etc/snort/rules/local.rules
# CrocLinux Local Snort Rules
# Add custom rules here

# Example: Alert on port scan
alert tcp any any -> $HOME_NET any (flags:S; msg:"Possible Port Scan"; threshold:type threshold, track by_src, count 20, seconds 10; sid:1000001; rev:1;)
EOF

  # Create Snort service file
  cat <<EOF > /etc/systemd/system/snort.service
[Unit]
Description=Snort IDS
After=network.target

[Service]
Type=simple
ExecStart=/usr/sbin/snort -A console -c /etc/snort/snort.conf -i $INTERFACE
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable snort
}

function configure_wazuh_enhanced() {
  echo "[+] Enhancing Wazuh configuration with Snort and Suricata integration"
  
  # Add Suricata integration to Wazuh
  cat <<'EOF' >> /var/ossec/etc/ossec.conf
  <localfile>
    <log_format>json</log_format>
    <location>/var/log/suricata/eve.json</location>
  </localfile>
  
  <localfile>
    <log_format>syslog</log_format>
    <location>/var/log/snort/alert</location>
  </localfile>
EOF

  # Create Wazuh rules for Suricata and Snort alerts
  cat <<'EOF' > /var/ossec/ruleset/rules/croc-suricata-rules.xml
<group name="suricata,">
  <rule id="100001" level="5">
    <decoded_as>json</decoded_as>
    <field name="event_type">alert</field>
    <description>Suricata Alert Detected</description>
  </rule>
  
  <rule id="100002" level="10">
    <decoded_as>json</decoded_as>
    <field name="event_type">alert</field>
    <field name="alert.severity">1</field>
    <description>Suricata High Severity Alert</description>
  </rule>
</group>
EOF

  cat <<'EOF' > /var/ossec/ruleset/rules/croc-snort-rules.xml
<group name="snort,">
  <rule id="100101" level="5">
    <if_sid>5710</if_sid>
    <match>snort</match>
    <description>Snort Alert Detected</description>
  </rule>
</group>
EOF
}

function configure_sigma() {
  echo "[+] Deploying Sigma rules into Wazuh"
  local sigma_dir="/var/ossec/ruleset/sigma"
  mkdir -p "$sigma_dir"
  git clone --depth 1 https://github.com/SigmaHQ/sigma.git "$sigma_dir/repo" || true
  /usr/bin/python3 -m pip install --no-cache-dir sigma-cli
  sigma-cli convert -t wazuh -r "$sigma_dir/repo/rules" -o "$sigma_dir/generated"
}

function configure_yara() {
  echo "[+] Deploying YARA community rules"
  local yara_dir="/var/ossec/ruleset/yara"
  mkdir -p "$yara_dir"
  git clone --depth 1 https://github.com/Yara-Rules/rules.git "$yara_dir/community" || true
}

function main() {
  install_wazuh
  configure_wazuh
  configure_wazuh_enhanced
  install_misp
  install_thehive_cortex
  install_velociraptor
  install_forensics
  install_grr
  install_detection_rules
  configure_suricata
  configure_snort
  configure_sigma
  configure_yara

  # Install management tools
  if [[ -f /opt/croc/scripts/services/install_management_tools.sh ]]; then
    bash /opt/croc/scripts/services/install_management_tools.sh
  fi

  echo "[+] Restarting services to apply configuration"
  systemctl restart wazuh-manager elasticsearch kibana filebeat
  systemctl restart misp-workers thehive cortex suricata snort osqueryd velociraptor
  
  echo "[+] Wazuh, Snort, and Suricata are now configured and running"
  echo "[+] Use management commands: croc-wazuh, croc-suricata, croc-snort"
}

main "$@"

