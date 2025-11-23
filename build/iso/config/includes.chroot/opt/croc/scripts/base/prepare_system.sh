#!/usr/bin/env bash

set -euo pipefail

LOG_FILE="/var/log/croc-linux-prepare.log"
exec > >(tee -a "$LOG_FILE") 2>&1

APT_OPTS=("-y" "-o" "Dpkg::Use-Pty=0")

function update_system() {
  echo "[+] Updating apt sources and upgrading base system"
  apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade "${APT_OPTS[@]}"
}

function install_base_packages() {
  echo "[+] Installing CrocLinux base packages"
  local packages=(
    xfce4 xfce4-goodies lightdm network-manager
    ufw apparmor apparmor-utils auditd fail2ban
    curl wget git gnupg2 software-properties-common
    build-essential python3 python3-pip python3-venv sudo
    unattended-upgrades cron openssh-server neofetch
    jq htop tmux fonts-jetbrains-mono
  )
  DEBIAN_FRONTEND=noninteractive apt-get install "${APT_OPTS[@]}" "${packages[@]}"
}

function harden_firewall() {
  echo "[+] Enabling and hardening UFW"
  ufw --force reset
  ufw default deny incoming
  ufw default allow outgoing
  ufw allow 22/tcp comment "Allow SSH management"
  ufw allow 5601/tcp comment "Allow Kibana"
  ufw allow 9200/tcp comment "Allow Elasticsearch"
  ufw allow 55000/tcp comment "Allow Wazuh agent enrollment"
  ufw allow 1514/udp comment "Allow Wazuh syslog"
  ufw --force enable
}

function configure_apparmor() {
  echo "[+] Enforcing AppArmor profiles"
  aa-enforce /etc/apparmor.d/* || true
  systemctl enable apparmor
}

function configure_auto_updates() {
  echo "[+] Enabling unattended security upgrades"
  dpkg-reconfigure --priority=low unattended-upgrades
}

function setup_xfce_profile() {
  echo "[+] Creating default XFCE profile for SOC use"
  local skel_dir="/etc/skel/.config"
  mkdir -p "$skel_dir/xfce4/xfconf/xfce-perchannel-xml"
  cat <<'EOF' > "$skel_dir/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="panels" type="array">
    <value type="int" value="0"/>
  </property>
  <property name="panel-0" type="empty">
    <property name="position" type="string" value="p=6;x=50;y=544"/>
    <property name="length" type="uint" value="100"/>
    <property name="size" type="uint" value="28"/>
    <property name="plugin-ids" type="array">
      <value type="int" value="0"/>
      <value type="int" value="1"/>
      <value type="int" value="2"/>
      <value type="int" value="3"/>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-0" type="string" value="applicationsmenu"/>
    <property name="plugin-1" type="string" value="tasklist"/>
    <property name="plugin-2" type="string" value="separator"/>
    <property name="plugin-3" type="string" value="systray"/>
  </property>
</channel>
EOF

  mkdir -p "$skel_dir/xfce4/terminal"
  cat <<'EOF' > "$skel_dir/xfce4/terminal/terminalrc"
[Configuration]
TerminalBell=FALSE
ColorPalette=#1E1E1E;#F44747;#619955;#FFAF00;#0A84FF;#B388FF;#57D9EA;#D0D0D0;#333333;#FF6E6E;#9DDC7C;#FFD866;#5AA2FF;#D4BFFF;#6FE4FF;#FFFFFF
BackgroundMode=TERMINAL_BACKGROUND_TRANSPARENT
BackgroundDarkness=0.85
FontName=JetBrains Mono 11
ScrollingBar=TERMINAL_SCROLLBAR_LEFT
EOF
}

function install_croc_banner() {
  echo "[+] Installing CrocLinux login banner"
  cat <<'EOF' > /etc/issue
        ___.-~~~~-.
  _/\  `~-._____'_____  ___
 {  `\         \      `' _ `.
  \   |  CROCODILE JAWS  ( | )
   `\ |    >>>  <<<      _\_/
     \|   ________   _.-'  \
      |  /  __   /\ /   _   \
      | /  /_/  /  Y  /_/\   \
      |/\______/\__|_/ /_/\___\

  ____                _     _                  
 / ___|_ __ ___   ___| |   (_)_ __  _   ___  __
| |   | '__/ _ \ / __| |   | | '_ \| | | \ \/ /
| |___| | | (_) | (__| |___| | | | | |_| |>  < 
 \____|_|  \___/ \___|_____|_|_| |_|\__,_/_/\_\
                                               

  CrocLinux — The Silent Guardian of Cyber Defense
EOF
  cp /etc/issue /etc/motd
}

function enable_services() {
  echo "[+] Enabling critical services"
  systemctl enable NetworkManager
  systemctl enable lightdm
  systemctl enable ssh
  systemctl enable auditd
  systemctl enable fail2ban
}

update_system
install_base_packages
harden_firewall
configure_apparmor
configure_auto_updates
setup_xfce_profile
install_croc_banner
enable_services

echo "[+] CrocLinux base preparation completed"

