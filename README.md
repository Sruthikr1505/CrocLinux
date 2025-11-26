# 🐊 CrocLinux — The Silent Guardian of Cyber Defense

> **Blue Team Security Distribution** - Pre-loaded with SOC, SIEM, DFIR, and threat intelligence tools. Built for defenders, by defenders.

**Works Exactly Like Kali Linux**: Easy ISO creation, pre-built VM images, organized menu structure, and simple installation process.

##  Quick Start

### 📖 Complete Guide: Publish → Build → Download → Use in VirtualBox

**👉 Start Here**: [GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)

This guide covers everything:
1. Publish CrocLinux to GitHub
2. Build ISO images (automated)
3. Download ISO from GitHub
4. Setup VirtualBox
5. Install and use CrocLinux

### ⚡ Quick Summary (5 Steps)

1. **Publish to GitHub**: Push code to GitHub repository
2. **Build ISO**: GitHub Actions builds automatically (30-60 min)
3. **Download ISO**: Get ISO from Releases or Artifacts
4. **VirtualBox Setup**: Create VM, attach ISO, install
5. **Use**: Login, access tools, start defending!

**📖 Full Step-by-Step**: [GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)
**📊 Visual Guide**: [Publish to VirtualBox](docs/PUBLISH-TO-VIRTUALBOX.md)
**⚡ Quick Reference**: [Quick Reference Card](docs/QUICK-REFERENCE.md)

## What's Included?

### 50+ Blue Team Tools (Pre-Installed)

####  Core Security Tools (Fully Configured)
- **Wazuh SIEM**: Complete SIEM/XDR platform with web interface
- **Suricata IDS/IPS**: High-performance network intrusion detection
- **Snort IDS**: Lightweight network intrusion detection
- **Management Commands**: `croc-wazuh`, `croc-suricata`, `croc-snort`

#### SIEM & Logging
- **Wazuh**, **Elasticsearch**, **Kibana**, **Logstash**
- **Filebeat**, **Packetbeat**, **Winlogbeat**, **Auditbeat**, **Metricbeat**

#### Threat Intelligence
- **MISP**, **OpenCTI**, **ThreatIngestor**, **Shodan CLI**, **VirusTotal CLI**

#### SOAR & Case Management
- **TheHive**, **Cortex**, **Shuffle**

#### Network Security Monitoring
- **Suricata**, **Snort**, **Zeek**, **Security Onion**, **Moloch**, **Arkime**
- **Wireshark**, **Tcpdump**, **NetworkMiner**

#### Endpoint Detection & Response
- **OSQuery**, **Sysmon**, **Velociraptor**, **GRR Rapid Response**

#### Forensics & Memory Analysis
- **Autopsy**, **SleuthKit**, **Volatility3**, **Rekall**, **SIFT**

#### Detection Rules
- **YARA**, **Sigma**, **YARA Rules**, **Sigma CLI**

#### Network Analysis
- **Nmap**, **Masscan**, **Zmap**, **Netcat**

#### Security Testing Tools
- **Burp Suite**, **OWASP ZAP**, **Nikto**, **SQLMap**
- **John the Ripper**, **Hashcat**, **Aircrack-ng**

#### Malware Analysis
- **Cuckoo Sandbox**, **REMnux**, **Joe Sandbox**

#### Antivirus & Rootkit Detection
- **ClamAV**, **Rkhunter**, **Chkrootkit**, **Lynis**

#### Vulnerability Scanning
- **OpenVAS**, **Nessus**

**Complete List**: See [Blue Team Enhancements](docs/blue-team-enhancements.md)

### Organized Menu (Like Kali Linux)
All tools are organized in the **Blue Team** menu:
- **SIEM & Dashboards**: Kibana, Wazuh console
- **Threat Intelligence**: MISP platform
- **Incident Response**: TheHive, Cortex, Velociraptor
- **Endpoint Forensics**: Autopsy, Volatility3, OSQuery
- **Network Monitoring**: Suricata dashboard
- **Automation**: Rule updates, CrocSec CLI

## 📋 System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| **RAM** | 4 GB | 8+ GB |
| **Disk** | 40 GB | 100+ GB |
| **CPU** | 2 cores | 4+ cores |
| **Architecture** | x86_64 | x86_64 |

## 💻 Installation

### Option 1: Virtual Machine (Easiest!)
1. Download `CrocLinux-v1.0.0.ova` from Releases
2. **VirtualBox**: File → Import Appliance → Select OVA → Import → Start
3. **VMware**: File → Open → Select OVA → Import → Play
4. Login: `analyst` / `Croc!2025`

### Option 2: ISO Installation
1. Download ISO from Releases
2. Create bootable USB (Rufus, Balena Etcher, or `dd`)
3. Boot from USB
4. Select "Install CrocLinux"
5. Follow installation wizard
6. Reboot and login

**Detailed Installation Guide**: See [Install Guide](docs/install-guide.md)

## 🎓 First Boot

After installation:

1. **Login**
   - Username: `analyst`
   - Password: `Croc!2025`

2. **Change Password** (Important!)
   ```bash
   passwd
   ```

3. **Access Tools**
   - Click **Applications** → **Blue Team** menu
   - All tools are organized by category
   - Or use terminal commands (see Quick Commands below)

4. **Update System**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

### Quick Commands
```bash
# CrocSec CLI Assistant
crocsec summary      # Get overview
crocsec status       # Check services
crocsec update_rules # Update rules

# Security Tools Management
croc-wazuh status      # Check Wazuh SIEM
croc-suricata status   # Check Suricata IDS
croc-snort status      # Check Snort IDS

# View Logs
croc-wazuh logs        # Wazuh alerts
croc-suricata logs     # Suricata alerts
croc-snort logs        # Snort alerts
```

**First Boot Guide**: See [First Boot Guide](docs/first-boot.md)
**Wazuh, Snort & Suricata Guide**: See [Complete Guide](docs/wazuh-snort-suricata-guide.md)

## ✅ Verify Setup

Before building, verify your setup:
```bash
./scripts/verify-setup.sh
```

This checks:
- ✅ Build scripts are present and executable
- ✅ GitHub Actions workflow is configured
- ✅ Package lists are complete
- ✅ Theme files are in place
- ✅ Documentation is complete
- ✅ All configuration scripts are ready

## 🔧 Building CrocLinux

### Automated Build (GitHub Actions)
**No setup required!** Builds automatically in the cloud:

1. Push code to GitHub
2. Go to **Actions** → **Build CrocLinux ISO** → **Run workflow**
3. Choose variant (`full`, `mini`, or `both`)
4. Download ISOs from **Artifacts** or **Releases**

### Local Build (Linux)
```bash
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools
chmod +x scripts/build/build_iso_variant.sh
./scripts/build/build_iso_variant.sh full   # Full ISO
./scripts/build/build_iso_variant.sh mini   # Mini ISO
```

**Full Build Instructions**: See [Build Instructions](docs/build-instructions.md)

## 📚 Documentation

### Getting Started
- **[GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)** - **Complete guide: Publish on GitHub → Build ISO → Use in VirtualBox**
- **[Step-by-Step Guide](docs/STEP-BY-STEP-GUIDE.md)** - Complete step-by-step instructions for everything
- **[Download Guide](docs/download-guide.md)** - How to download and use CrocLinux (ISO & VM images)
- **[Download & Virtualization](docs/download-virtualization-guide.md)** - Download and run in VirtualBox/VMware
- **[Install Guide](docs/install-guide.md)** - Detailed installation instructions
- **[First Boot Guide](docs/first-boot.md)** - First boot experience
- **[Usage Guide](docs/usage-guide.md)** - How to use CrocLinux tools and services

### Customization
- **[Theme Guide](docs/theme-guide.md)** - Hacker aesthetic and dark theme customization
- **[Wazuh, Snort & Suricata Guide](docs/wazuh-snort-suricata-guide.md)** - **Complete guide for core security tools**
- **[Blue Team Enhancements](docs/blue-team-enhancements.md)** - Complete list of Blue Team tools and features

### Development
- **[Publishing Guide](docs/publishing-guide.md)** - How to publish CrocLinux to GitHub
- **[VM Image Creation](docs/vm-image-creation.md)** - Creating pre-built VM images
- **[Build Instructions](docs/build-instructions.md)** - Building from source

### Reference
- **[Final Setup Guide](docs/FINAL-SETUP-GUIDE.md)** - **Complete setup verification and quick start**
- **[Kali Linux Compatibility](docs/kali-linux-compatibility.md)** - Detailed comparison with Kali Linux
- **[Project Concept](docs/project-concept.md)** - Project goals, outcomes, and vision
- **[Product Overview](docs/product-overview.md)** - Feature overview
- **[System Architecture](docs/system-architecture.md)** - Architecture diagrams
- **[Defaults & Services](docs/defaults-and-services.md)** - Credentials and services
- **[Complete Guide](docs/complete-guide.md)** - Comprehensive reference guide
- **[Roadmap](docs/roadmap.md)** - Future features

## 🎨 Theme

CrocLinux features **two theme options** designed for SOC analysts:

### Hacker Aesthetic Theme (Default) - Green on Black
- **Pure Black Background**: Immersive hacker aesthetic (#000000)
- **Terminal Green**: Classic green text (#00ff00) for Matrix-style look
- **Glow Effects**: Green text glow for authentic terminal feel
- **Blue Highlights**: CrocLinux brand color (#00a8ff) for accents
- **JetBrains Mono Font**: Technical, monospace font

### Dark Theme (Alternative) - Blue Accents
- **Dark Background**: Professional dark theme (#1a1a1a)
- **Blue Accents**: CrocLinux brand color (#00a8ff) for visual feedback
- **High Contrast**: Optimized for readability
- **Professional Look**: Clean, organized interface

**Switch Themes**: Run `sudo /opt/croc/scripts/base/configure_theme.sh hacker` or `dark`

**Theme Guide**: See [Theme Guide](docs/theme-guide.md) for customization options.

## 🔒 Security

**Important**: Change all default passwords immediately after installation!

- **System Password**: `passwd`
- **Service Passwords**: See [Defaults & Services](docs/defaults-and-services.md)
- **Hardening**: Pre-configured AppArmor, UFW, auditd, Fail2Ban

## ✅ Kali Linux Compatibility

**CrocLinux works exactly like Kali Linux:**

- ✅ **ISO Creation**: Automated builds via GitHub Actions or local scripts
- ✅ **VM Images**: Pre-built OVA files for VirtualBox/VMware
- ✅ **Menu Organization**: Tools organized by category (like Kali)
- ✅ **Easy Installation**: Simple installation process
- ✅ **Pre-Configured**: All tools ready to use out of the box
- ✅ **Documentation**: Comprehensive guides and tutorials

**See**: [Kali Linux Compatibility Guide](docs/kali-linux-compatibility.md) for detailed comparison.

## 🆘 Support

- **Issues**: Report on [GitHub Issues](https://github.com/your-username/CrocLinux/issues)
- **Documentation**: See `docs/` directory
- **Community**: Join discussions on GitHub Discussions

## 🛠️ Features

### Pre-Configured Tools
- All Blue Team tools pre-installed and configured
- Automated integrations between tools
- Ready-to-use dashboards and workflows

### Easy to Use
- Organized menu structure (like Kali Linux)
- One-click tool launchers
- CrocSec CLI assistant for quick help

### Production Ready
- Hardened by default
- Enterprise-grade security
- Scalable architecture

## 🚀 Roadmap

- **v1.0**: Base OS + Core Blue Team Tools ✅
- **v1.1**: CrocSec AI Assistant (CLI Chatbot) ⚙️
- **v1.2**: Cloud Sync for MISP & Wazuh 🚧
- **v2.0**: AI Anomaly Detection Engine 🔮
- **v2.5**: Dockerized Enterprise Deployment 🔜

**Full Roadmap**: See [Roadmap](docs/roadmap.md)

## 📄 License

CrocLinux is released under the MIT License. See `LICENSE` for details.

## 🙏 Credits

Inspired by [Kali Linux](https://www.kali.org/) - Built for Blue Teams, by Blue Teams.

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Download Now**: [Releases](https://github.com/your-username/CrocLinux/releases)
