# CrocLinux Step-by-Step Complete Guide

## 🎯 Complete Step-by-Step Instructions

This guide provides exact step-by-step instructions for every aspect of CrocLinux - from setup to usage.

---

## 📋 Part 1: Initial Setup & Verification

### Step 1: Verify Your Setup
```bash
# Navigate to project directory
cd "/Users/sruthikr/Desktop/Croc Linux "

# Run verification script
./scripts/verify-setup.sh
```

**Expected Output:**
```
✅ All checks passed! CrocLinux is ready to build.
```

**If errors appear:**
- Fix missing files
- Make scripts executable: `chmod +x scripts/**/*.sh`
- Re-run verification

---

## 📦 Part 2: Building CrocLinux

### Option A: Build Using GitHub Actions (Recommended - Easiest)

#### Step 1: Prepare Git Repository
```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit files
git commit -m "Initial CrocLinux release"

# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git

# Push to GitHub
git push -u origin main
```

#### Step 2: Create GitHub Repository
1. Go to: https://github.com/new
2. Repository name: `CrocLinux`
3. Description: `CrocLinux — The Silent Guardian of Cyber Defense`
4. Choose: Public or Private
5. Click: **Create repository**

#### Step 3: Trigger Automated Build
1. Go to your GitHub repository
2. Click: **Actions** tab
3. Click: **Build CrocLinux ISO** workflow
4. Click: **Run workflow** button
5. Select variant: `both` (for full + mini)
6. Click: **Run workflow** button
7. Wait: 30-60 minutes for build to complete

#### Step 4: Download ISOs
1. Go to: **Actions** tab
2. Click on the completed workflow run
3. Scroll down to **Artifacts**
4. Click: **croclinux-isos**
5. Download: `CrocLinux-full-YYYYMMDD.iso` and `CrocLinux-mini-YYYYMMDD.iso`

### Option B: Build Locally (Linux Required)

#### Step 1: Install Build Dependencies
```bash
# Update package list
sudo apt-get update

# Install required packages
sudo apt-get install -y \
    live-build \
    debootstrap \
    xorriso \
    squashfs-tools \
    git
```

#### Step 2: Build ISO
```bash
# Navigate to project
cd "/Users/sruthikr/Desktop/Croc Linux "

# Make script executable
chmod +x scripts/build/build_iso_variant.sh

# Build Full ISO
./scripts/build/build_iso_variant.sh full

# Wait: 30-60 minutes
# Output: release/CrocLinux-full-YYYYMMDD.iso

# Build Mini ISO (optional)
./scripts/build/build_iso_variant.sh mini

# Wait: 30-60 minutes
# Output: release/CrocLinux-mini-YYYYMMDD.iso
```

#### Step 3: Verify ISOs
```bash
# Check ISO files
ls -lh release/*.iso

# Verify checksums
cd release
sha256sum -c sha256sums.txt
```

---

## 💻 Part 3: Creating VM Images

### Step 1: Create Release Tag
```bash
# Create version tag
git tag v1.0.0

# Push tag to GitHub
git push origin v1.0.0
```

### Step 2: GitHub Actions Creates VM Images
1. GitHub Actions automatically:
   - Builds ISOs
   - Creates VM images (OVA)
   - Uploads to GitHub Releases
   - Generates checksums

2. Wait: 60-90 minutes for complete build

### Step 3: Download VM Images
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux/releases
2. Click on: `v1.0.0` release
3. Download: `CrocLinux-v1.0.0.ova`
4. Download: `sha256sums.txt` (for verification)

### Step 4: Verify VM Image
```bash
# Verify checksum
sha256sum -c sha256sums.txt
```

---

## 📥 Part 4: Downloading CrocLinux

### Step 1: Go to GitHub Releases
1. Visit: https://github.com/YOUR-USERNAME/CrocLinux/releases
2. Click on: Latest release (e.g., `v1.0.0`)

### Step 2: Choose Download Type

#### Option A: Download ISO (For Installation)
1. Download: `CrocLinux-full-YYYYMMDD.iso` (4-5 GB)
   - OR
2. Download: `CrocLinux-mini-YYYYMMDD.iso` (2-3 GB)

#### Option B: Download VM Image (Easiest - Recommended)
1. Download: `CrocLinux-v1.0.0.ova` (8-12 GB)

### Step 3: Download Checksums
1. Download: `sha256sums.txt`
2. Download: `sha512sums.txt`

### Step 4: Verify Downloads
```bash
# Verify SHA-256
sha256sum -c sha256sums.txt

# Verify SHA-512
sha512sum -c sha512sums.txt
```

---

## 🖥️ Part 5: Installing CrocLinux

### Method A: Using VM Image (Easiest - Recommended)

#### Step 1: Import into VirtualBox
1. Open: VirtualBox
2. Click: **File** → **Import Appliance**
3. Click: **Choose** button
4. Select: `CrocLinux-v1.0.0.ova`
5. Click: **Next**
6. Review settings (Memory: 4096 MB, Disk: 60+ GB)
7. Click: **Import**
8. Wait: 5-10 minutes for import

#### Step 2: Start VM
1. Select: CrocLinux VM
2. Click: **Start** button
3. Wait: 30-60 seconds for boot
4. Login screen appears

#### Step 3: Login
- **Username**: `analyst`
- **Password**: `Croc!2025`
- Press: **Enter**

#### Step 4: Change Password (Important!)
```bash
# Change password
passwd

# Enter new password twice
# Example: YourSecurePassword123!
```

### Method B: Using ISO (For Physical Installation)

#### Step 1: Create Bootable USB

**On macOS:**
```bash
# Find USB device
diskutil list

# Unmount USB (replace X with your disk number)
diskutil unmountDisk /dev/diskX

# Create bootable USB
sudo dd if=CrocLinux-full-YYYYMMDD.iso of=/dev/rdiskX bs=4m && sync

# Eject USB
diskutil eject /dev/diskX
```

**On Windows:**
1. Download: [Rufus](https://rufus.ie) or [Balena Etcher](https://www.balena.io/etcher)
2. Open: Rufus or Balena Etcher
3. Select: ISO file
4. Select: USB drive
5. Click: **Start** or **Flash**
6. Wait: 5-10 minutes

**On Linux:**
```bash
# Find USB device
lsblk

# Create bootable USB (replace X with your device)
sudo dd if=CrocLinux-full-YYYYMMDD.iso of=/dev/sdX bs=4M status=progress && sync
```

#### Step 2: Boot from USB
1. Insert: USB drive
2. Restart: Computer
3. Press: Boot menu key (F12, F2, ESC - depends on system)
4. Select: USB drive
5. Press: **Enter**

#### Step 3: Install CrocLinux
1. Boot menu appears
2. Select: **Install CrocLinux**
3. Press: **Enter**
4. Follow installation wizard:
   - **Language**: English
   - **Locale**: en_US.UTF-8
   - **Keyboard**: US
   - **Hostname**: croc-soc (or your choice)
   - **Username**: analyst
   - **Password**: Croc!2025 (change later!)
   - **Partitioning**: Guided - use entire disk
   - **Confirm**: Write changes to disk
5. Wait: 20-30 minutes for installation
6. Remove: USB drive when prompted
7. Reboot: System

#### Step 4: First Boot
1. System reboots
2. Login screen appears
3. Login: `analyst` / `Croc!2025`
4. Change password: `passwd`

---

## 🚀 Part 6: First Boot & Configuration

### Step 1: Login
- **Username**: `analyst`
- **Password**: `Croc!2025` (or your new password)

### Step 2: Change Password (Critical!)
```bash
# Change password
passwd

# Enter current password: Croc!2025
# Enter new password: (your secure password)
# Confirm new password: (your secure password)
```

### Step 3: Update System
```bash
# Update package list
sudo apt update

# Upgrade system
sudo apt upgrade -y

# Wait: 10-20 minutes
```

### Step 4: Check Services
```bash
# Check service status
sudo systemctl status wazuh-manager elasticsearch kibana

# Start services if needed
sudo systemctl start wazuh-manager elasticsearch kibana

# Enable services on boot
sudo systemctl enable wazuh-manager elasticsearch kibana
```

### Step 5: Access Tools

#### Via Menu
1. Click: **Applications** (top-left)
2. Click: **Blue Team**
3. Select: Tool category
4. Click: Tool name

#### Via Web Interfaces
1. Open: Web browser
2. Navigate to:
   - **Kibana**: https://127.0.0.1:5601
   - **Wazuh**: https://127.0.0.1:5601/app/wazuh
   - **MISP**: https://127.0.0.1
   - **TheHive**: http://127.0.0.1:9000
   - **Cortex**: http://127.0.0.1:9001
   - **Velociraptor**: https://127.0.0.1:8000

#### Via Terminal
```bash
# Open terminal
# Press: Ctrl+Alt+T

# Use CrocSec CLI
crocsec summary
crocsec status
crocsec update_rules
```

---

## 🎨 Part 7: Customizing Theme

### Step 1: Check Current Theme
```bash
# Check current theme
xfconf-query -c xsettings -p /Net/ThemeName
```

### Step 2: Switch to Hacker Theme (Green on Black)
```bash
# Apply hacker aesthetic theme
sudo /opt/croc/scripts/base/configure_theme.sh hacker

# Logout and login again to see changes
```

### Step 3: Switch to Dark Theme (Blue Accents)
```bash
# Apply dark theme
sudo /opt/croc/scripts/base/configure_theme.sh dark

# Logout and login again to see changes
```

### Step 4: Customize Terminal
1. Right-click: Terminal
2. Click: **Preferences**
3. Adjust: Colors, fonts, transparency
4. Click: **OK**

---

## 🛠️ Part 8: Using Tools

### Step 1: Access Kibana Dashboard
1. Open: Web browser
2. Navigate: https://127.0.0.1:5601
3. Login: `elastic` / `CHANGEME`
4. Click: **CrocSec Threat Correlation** dashboard
5. View: Security events and alerts

### Step 2: Access Wazuh Console
1. Navigate: https://127.0.0.1:5601/app/wazuh
2. View: Security events
3. Check: Agent status
4. Review: Rules and alerts

### Step 3: Access MISP Platform
1. Navigate: https://127.0.0.1
2. Login: `admin@croc.local` / `Croc!2025`
3. View: Threat intelligence events
4. Import: IOCs

### Step 4: Use CrocSec CLI
```bash
# Get overview
crocsec summary

# Check service status
crocsec status

# Update detection rules
sudo croc-update-rules

# Import IOCs
sudo croc-ioc-import /path/to/ioc.json
```

### Step 5: Update Detection Rules
```bash
# Update Sigma and YARA rules
sudo croc-update-rules

# Verify update
sudo systemctl status wazuh-manager
```

---

## 🔧 Part 9: Configuration

### Step 1: Configure Wazuh
```bash
# Edit Wazuh configuration
sudo nano /var/ossec/etc/ossec.conf

# Restart Wazuh
sudo systemctl restart wazuh-manager
```

### Step 2: Configure MISP
1. Navigate: https://127.0.0.1
2. Login: `admin@croc.local` / `Croc!2025`
3. Go to: **Administration** → **Server Settings**
4. Configure: API keys, sync settings
5. Save: Changes

### Step 3: Configure TheHive
1. Navigate: http://127.0.0.1:9000
2. Create: Admin account (first login)
3. Configure: Analyzers, integrations
4. Set up: Case templates

### Step 4: Configure Firewall
```bash
# Check firewall status
sudo ufw status

# Allow additional ports if needed
sudo ufw allow 8080/tcp

# Enable firewall
sudo ufw enable
```

---

## 📊 Part 10: Monitoring & Maintenance

### Step 1: Monitor Services
```bash
# Check all services
sudo systemctl status wazuh-manager elasticsearch kibana misp-workers thehive cortex

# View service logs
sudo journalctl -u wazuh-manager -f
sudo journalctl -u elasticsearch -f
```

### Step 2: Monitor System Resources
```bash
# Check CPU and memory
htop

# Check disk usage
df -h

# Check network
sudo netstat -tulpn
```

### Step 3: Update System
```bash
# Update package list
sudo apt update

# Upgrade packages
sudo apt upgrade -y

# Update detection rules
sudo croc-update-rules
```

### Step 4: Backup Configuration
```bash
# Backup Wazuh config
sudo cp -r /var/ossec/etc /backup/wazuh-config

# Backup MISP data
sudo cp -r /var/www/MISP /backup/misp-data

# Backup Elasticsearch indices
sudo curl -X POST "localhost:9200/_snapshot/backup/snapshot_1"
```

---

## 🆘 Part 11: Troubleshooting

### Problem: Services Won't Start
```bash
# Check service status
sudo systemctl status <service-name>

# Check logs
sudo journalctl -u <service-name> -f

# Restart service
sudo systemctl restart <service-name>
```

### Problem: Web Interface Not Accessible
```bash
# Check if service is running
sudo systemctl status kibana wazuh-manager

# Check firewall
sudo ufw status

# Check ports
sudo netstat -tulpn | grep -E '5601|9200|55000'
```

### Problem: Theme Not Applying
```bash
# Reapply theme
sudo /opt/croc/scripts/base/configure_theme.sh hacker

# Restart XFCE
xfce4-panel -r

# Logout and login again
```

### Problem: ISO Won't Boot
```bash
# Verify ISO integrity
sha256sum -c sha256sums.txt

# Try different USB creation tool
# Try different USB drive
# Check BIOS/UEFI settings
```

---

## ✅ Part 12: Verification Checklist

### After Installation
- [ ] Login successful
- [ ] Password changed
- [ ] System updated
- [ ] Services running
- [ ] Web interfaces accessible
- [ ] Tools accessible via menu
- [ ] Theme applied correctly
- [ ] Network working
- [ ] Firewall configured

### After Configuration
- [ ] Wazuh configured
- [ ] MISP configured
- [ ] TheHive configured
- [ ] Rules updated
- [ ] IOCs imported
- [ ] Dashboards working
- [ ] Monitoring active

---

## 🎯 Quick Reference

### Default Credentials
- **System**: `analyst` / `Croc!2025`
- **Kibana**: `elastic` / `CHANGEME`
- **Wazuh**: `wazuh` / `CHANGE_ME`
- **MISP**: `admin@croc.local` / `Croc!2025`

### Important Commands
```bash
# Service management
sudo systemctl start/stop/restart/status <service>

# Update rules
sudo croc-update-rules

# CrocSec CLI
crocsec summary/status/update_rules

# Theme switch
sudo /opt/croc/scripts/base/configure_theme.sh hacker/dark
```

### Important URLs
- **Kibana**: https://127.0.0.1:5601
- **Wazuh**: https://127.0.0.1:5601/app/wazuh
- **MISP**: https://127.0.0.1
- **TheHive**: http://127.0.0.1:9000
- **Cortex**: http://127.0.0.1:9001
- **Velociraptor**: https://127.0.0.1:8000

---

## 🎉 Success!

You now have CrocLinux fully set up and ready to use!

**Next Steps:**
1. Explore tools via **Applications** → **Blue Team** menu
2. Configure services for your environment
3. Import threat intelligence
4. Set up monitoring dashboards
5. Start defending!

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Need Help?** See [Complete Guide](complete-guide.md) or [Documentation Index](../README.md)

