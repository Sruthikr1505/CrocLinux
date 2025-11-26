#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="/var/log/croc-linux-hardening.log"
exec > >(tee -a "$LOG_FILE") 2>&1

SYSCTL_CONF=/etc/sysctl.d/99-croc-linux.conf

function configure_sysctl() {
  echo "[+] Applying kernel hardening parameters"
  cat <<'EOF' > "$SYSCTL_CONF"
kernel.kptr_restrict = 2
kernel.dmesg_restrict = 1
kernel.yama.ptrace_scope = 2
kernel.randomize_va_space = 2
net.ipv4.ip_forward = 0
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv4.tcp_syncookies = 1
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0
fs.suid_dumpable = 0
EOF
  sysctl --system
}

function secure_sshd() {
  echo "[+] Hardening SSH daemon"
  cat <<'EOF' > /etc/ssh/sshd_config.d/99-croc-linux.conf
Port 22
Protocol 2
PermitRootLogin no
PasswordAuthentication no
KexAlgorithms curve25519-sha256,aes128-ctr,aes256-ctr
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com
ClientAliveInterval 300
ClientAliveCountMax 1
LoginGraceTime 30
AllowTcpForwarding no
X11Forwarding no
EOF
  systemctl restart ssh
}

function configure_auditd() {
  echo "[+] Deploying auditd policy for key SOC events"
  cat <<'EOF' > /etc/audit/rules.d/croc-linux.rules
-D
-b 8192
-a always,exit -F arch=b64 -S execve -k exec_monitor
-a always,exit -F arch=b64 -S connect -F a0=2 -k net_monitor
-w /etc/passwd -p wa -k user_mgmt
-w /etc/group -p wa -k user_mgmt
-w /etc/sudoers -p wa -k priv_esc
-w /etc/ssh/sshd_config -p wa -k ssh_config
-w /var/ossec/logs/alerts/alerts.json -p r -k wazuh_alerts
EOF
  augenrules --load
  systemctl restart auditd
}

function configure_fail2ban() {
  echo "[+] Configuring Fail2Ban for SSH protection"
  cat <<'EOF' > /etc/fail2ban/jail.d/croc-linux.conf
[sshd]
enabled = true
port = ssh
filter = sshd
maxretry = 5
bantime = 3600
EOF
  systemctl restart fail2ban
}

function enable_app_armor_profiles() {
  echo "[+] Enabling custom AppArmor profiles"
  mkdir -p /etc/apparmor.d/local
  cat <<'EOF' > /etc/apparmor.d/local/usr.bin.curl
profile usr.bin.curl flags=(attach_disconnected) {
  # Inherit existing rules and only permit network access
  # from defined interfaces. Extend as required by SOC tooling.
  #include <abstractions/base>
  network inet stream,
  network inet6 stream,
}
EOF
  systemctl reload apparmor
}

function enforce_password_policy() {
  echo "[+] Setting password policy"
  apt-get install -y libpam-pwquality
  cat <<'EOF' > /etc/security/pwquality.conf
minlen = 14
minclass = 4
maxrepeat = 2
maxsequence = 3
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
EOF
}

configure_sysctl
secure_sshd
configure_auditd
configure_fail2ban
enable_app_armor_profiles
enforce_password_policy

echo "[+] CrocLinux hardening complete"

