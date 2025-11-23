# CrocLinux WSL Distribution (Experimental)

## Overview
Guidance for packaging CrocLinux as a Windows Subsystem for Linux (WSL) distribution. This requires building a root filesystem (rootfs) that complies with WSL expectations.

## Prerequisites (on Windows host)
- Windows 11 / Windows 10 22H2+
- Windows Terminal or PowerShell 7
- WSL 2 enabled
- Ubuntu (or Debian) WSL instance for tooling
- 30 GB free disk space

## Steps

### 1. Build CrocLinux rootfs (in WSL Ubuntu shell)
```bash
sudo apt-get update
sudo apt-get install -y debootstrap qemu-user-static tar xz-utils

# Create working directories
mkdir -p ~/croclinux-rootfs
sudo debootstrap --arch=amd64 bookworm ~/croclinux-rootfs http://deb.debian.org/debian

# Copy CrocLinux scripts into rootfs
sudo rsync -a /mnt/c/Users/<you>/CrocLinux/scripts/ ~/croclinux-rootfs/opt/croc/scripts/

# Chroot to configure
sudo chroot ~/croclinux-rootfs /bin/bash <<'CHROOT'
set -e
apt-get update
apt-get install -y systemd-sysv
/opt/croc/scripts/base/prepare_system.sh
/opt/croc/scripts/base/hardening.sh
/opt/croc/scripts/services/install_blue_team_stack.sh
/opt/croc/scripts/automation/setup_integrations.sh
# WSL tweaks
rm -f /etc/systemd/system/getty.target.wants/getty@tty1.service
CHROOT
```

### 2. Strip unneeded components for WSL
```bash
sudo chroot ~/croclinux-rootfs /bin/bash <<'CHROOT'
apt-get clean
rm -rf /var/cache/apt/archives/*
rm -rf /tmp/*
CHROOT
```

### 3. Export rootfs
```bash
cd ~/croclinux-rootfs
sudo tar --numeric-owner -czf ../CrocLinux-wsl-rootfs.tar.gz .
```

### 4. Import into Windows
```powershell
wsl --import CrocLinux C:\WSL\CrocLinux C:\path\to\CrocLinux-wsl-rootfs.tar.gz --version 2
wsl -d CrocLinux --user analyst
```

### 5. Post-import configuration
Inside WSL CrocLinux:
```bash
sudo ln -s /usr/lib/systemd/systemd /sbin/init
sudo tee /etc/wsl.conf <<'WSL'
[boot]
systemd=true

[user]
default=analyst
WSL
```
Exit and run `wsl --shutdown` then re-enter to enable systemd.

## Packaging for Distribution
- Compress `CrocLinux-wsl-rootfs.tar.gz` and publish alongside instructions.
- Provide SHA sums and optional PowerShell installer script.

> WSL build is optional/experimental; revisit service enablement to ensure Wazuh/Elastic start under systemd in WSL.
