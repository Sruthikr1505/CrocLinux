#!/usr/bin/env bash

set -euo pipefail

echo "[+] Running CrocLinux post-install configuration"

user=${1:-analyst}

adduser "$user" sudo
adduser "$user" adm
adduser "$user" osquery

timedatectl set-timezone UTC

/opt/croc/scripts/base/prepare_system.sh
/opt/croc/scripts/base/hardening.sh
/opt/croc/scripts/services/install_blue_team_stack.sh
/opt/croc/scripts/automation/setup_integrations.sh

echo "[+] CrocLinux post-install tasks complete"

