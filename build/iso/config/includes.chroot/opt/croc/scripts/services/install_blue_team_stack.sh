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
  echo "[+] Installing YARA, Sigma, OSQuery, Sysmon, Suricata"
  apt-get install "${APT_OPTS[@]}" yara yara-doc yara-tools sigma python3-sigma osquery suricata sysmonforlinux

  systemctl enable suricata
  systemctl enable osqueryd
}

function configure_suricata() {
  echo "[+] Applying CrocLinux Suricata tuning"
  cat <<'EOF' > /etc/suricata/suricata.yaml
%YAML 1.1
---
default-log-level: info
af-packet:
  - interface: eth0
    cluster-id: 99
    cluster-type: cluster_flow
    defrag: yes
    use-mmap: yes
outputs:
  - eve-log:
      enabled: yes
      filetype: unix_stream
      filename: /var/run/suricata/eve.sock
      types:
        - alert
        - dns
        - http
        - tls
        - ssh
        - flow
        - fileinfo
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
  install_misp
  install_thehive_cortex
  install_velociraptor
  install_forensics
  install_grr
  install_detection_rules
  configure_suricata
  configure_sigma
  configure_yara

  echo "[+] Restarting services to apply configuration"
  systemctl restart wazuh-manager elasticsearch kibana filebeat
  systemctl restart misp-workers thehive cortex suricata osqueryd velociraptor
}

main "$@"

