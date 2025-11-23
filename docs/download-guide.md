# CrocLinux Download Guide

## Quick Start (Just Like Kali Linux!)

### Option 1: Download Pre-Built ISO Images

1. **Go to Releases Page**
   - Visit: https://github.com/your-username/CrocLinux/releases
   - Click on the latest release (e.g., `v1.0.0`)

2. **Download ISO**
   - **Full ISO**: Complete CrocLinux with all Blue Team tools (~4-5 GB)
   - **Mini ISO**: Lightweight version with core tools (~2-3 GB)
   - Click the ISO file to download

3. **Verify Checksums** (Recommended)
   ```bash
   # Download sha256sums.txt from releases page
   sha256sum -c sha256sums.txt
   ```

4. **Create Bootable USB**
   - **macOS**: Use `dd` or Balena Etcher
   - **Windows**: Use Rufus or Balena Etcher
   - **Linux**: Use `dd` or `balena-etcher-electron`

5. **Boot and Install**
   - Boot from USB
   - Select "Install CrocLinux"
   - Follow the installation wizard

### Option 2: Download Pre-Built VM Images (Easiest!)

1. **Download OVA File**
   - Go to Releases page
   - Download `CrocLinux-v1.0.0.ova` (VirtualBox/VMware compatible)

2. **Import into VirtualBox**
   - Open VirtualBox
   - Click **File** → **Import Appliance**
   - Select the `.ova` file
   - Click **Import**
   - Click **Start** to launch CrocLinux

3. **Import into VMware**
   - Open VMware Workstation/Fusion
   - Click **File** → **Open**
   - Select the `.ova` file
   - Click **Import**
   - Click **Play** to start CrocLinux

**Default Credentials:**
- Username: `analyst`
- Password: `Croc!2025`

> **Note**: Change the password immediately after first login!

## System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 4 GB | 8+ GB |
| Disk | 40 GB | 100+ GB |
| CPU | 2 cores | 4+ cores |
| Architecture | x86_64 | x86_64 |

## Virtual Machine Setup (VirtualBox)

1. **Create New VM**
   - Name: `CrocLinux`
   - Type: `Linux`
   - Version: `Debian (64-bit)`
   - Memory: 4096 MB (4 GB)
   - Hard disk: 60+ GB

2. **Attach ISO**
   - Settings → Storage → Empty CD icon
   - Select downloaded ISO file

3. **Start VM**
   - Click **Start**
   - Select "Install CrocLinux" from boot menu
   - Follow installation prompts

## Virtual Machine Setup (VMware)

1. **Create New VM**
   - Select "Typical" installation
   - Choose "I will install the operating system later"
   - Select "Linux" → "Debian 12.x 64-bit"
   - Set RAM: 4096 MB
   - Set disk: 60+ GB

2. **Attach ISO**
   - VM Settings → CD/DVD
   - Select "Use ISO image file"
   - Browse to downloaded ISO

3. **Start VM**
   - Click **Play**
   - Follow installation wizard

## What's Included?

### Full ISO
- **SIEM & Dashboards**: Wazuh, Elasticsearch, Kibana
- **Threat Intelligence**: MISP
- **Incident Response**: TheHive, Cortex, Velociraptor, GRR
- **Forensics**: Autopsy, Volatility3
- **Network Monitoring**: Suricata, OSQuery
- **Automation**: CrocSec CLI, rule update scripts

### Mini ISO
- **SIEM & Dashboards**: Wazuh, Elasticsearch, Kibana
- **Network Monitoring**: Suricata, OSQuery
- **Core Tools**: YARA, Sigma rules

## First Boot

After installation:

1. **Login**
   - Username: `analyst`
   - Password: `Croc!2025`

2. **Change Password** (Important!)
   ```bash
   passwd
   ```

3. **Update System**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

4. **Access Tools**
   - Click **Applications** → **Blue Team** menu
   - All tools are organized by category
   - Or use `crocsec` CLI assistant

## Troubleshooting

### ISO won't boot
- Verify ISO checksums match
- Try different USB drive
- Check BIOS/UEFI settings
- Use different USB creation tool

### VM is slow
- Increase RAM allocation (8+ GB)
- Enable virtualization in BIOS
- Allocate more CPU cores

### Installation fails
- Check disk space (need 40+ GB free)
- Verify ISO integrity
- Try different installation method

## Support

- **Documentation**: See `docs/` directory
- **Issues**: Report on GitHub Issues
- **Community**: Join discussions on GitHub Discussions

## Security Notice

**Important**: Change all default passwords immediately after installation!
- System password: `passwd`
- Service passwords: See `docs/defaults-and-services.md`

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

