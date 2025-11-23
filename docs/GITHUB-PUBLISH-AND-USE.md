# Complete Guide: Publish CrocLinux on GitHub & Use in VirtualBox

## 🎯 Overview
This guide walks you through publishing CrocLinux on GitHub, building ISO images, downloading them, and using them in VirtualBox - step by step.

---

## 📋 Part 1: Prepare Your Project

### Step 1: Verify Your Setup
```bash
# Navigate to project directory
cd "/Users/sruthikr/Desktop/Croc Linux "

# Run verification script
./scripts/verify-setup.sh
```

**Expected Result**: ✅ All checks passed!

**If errors appear**: Fix them before proceeding.

---

## 📦 Part 2: Publish to GitHub

### Step 1: Initialize Git Repository (If Not Done)
```bash
# Check if git is initialized
git status

# If not initialized, run:
git init
git add .
git commit -m "Initial CrocLinux release - Complete Blue Team distribution"
```

### Step 2: Create GitHub Repository

1. **Go to GitHub**
   - Open: https://github.com/new
   - Or click: **+** → **New repository**

2. **Fill Repository Details**
   - **Repository name**: `CrocLinux`
   - **Description**: `CrocLinux — The Silent Guardian of Cyber Defense - Blue Team Security Distribution`
   - **Visibility**: Choose **Public** (recommended) or **Private**
   - **DO NOT** check "Initialize with README" (we already have files)
   - Click: **Create repository**

3. **Copy Repository URL**
   - GitHub will show you the repository URL
   - Copy it (e.g., `https://github.com/YOUR-USERNAME/CrocLinux.git`)

### Step 3: Connect Local Repository to GitHub
```bash
# Add remote (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git

# Verify remote
git remote -v

# Set main branch
git branch -M main

# Push to GitHub
git push -u origin main
```

**If asked for credentials:**
- Use GitHub Personal Access Token (not password)
- Create token: GitHub → Settings → Developer settings → Personal access tokens → Generate new token
- Select scopes: `repo` (full control)

### Step 4: Verify Upload
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux
2. Verify: All files are visible
3. Check: README.md displays correctly

---

## 🔨 Part 3: Build ISO Images (GitHub Actions)

### Step 1: Trigger Automated Build
1. **Go to Your Repository**
   - Visit: https://github.com/YOUR-USERNAME/CrocLinux

2. **Open Actions Tab**
   - Click: **Actions** tab (top menu)

3. **Select Workflow**
   - Click: **Build CrocLinux ISO** (left sidebar)
   - If not visible, click: **Set up workflow** or wait for first push

4. **Run Workflow**
   - Click: **Run workflow** button (right side)
   - Select variant: `both` (builds full + mini)
   - Click: **Run workflow** button

5. **Wait for Build**
   - Build takes: **30-60 minutes**
   - Watch progress: Click on the running workflow
   - Status: Yellow (running) → Green (success) or Red (failed)

### Step 2: Download ISOs from Artifacts
1. **After Build Completes**
   - Go to: **Actions** tab
   - Click on: Completed workflow run (green checkmark)

2. **Download Artifacts**
   - Scroll down to: **Artifacts** section
   - Click: **croclinux-isos**
   - Download: The ZIP file contains your ISOs

3. **Extract ISOs**
   ```bash
   # Extract downloaded ZIP
   unzip croclinux-isos.zip
   
   # You'll find:
   # - CrocLinux-full-YYYYMMDD.iso
   # - CrocLinux-mini-YYYYMMDD.iso
   # - sha256sums.txt
   # - sha512sums.txt
   ```

### Step 3: Create GitHub Release (Optional but Recommended)
1. **Create Release Tag**
   ```bash
   # Create version tag
   git tag v1.0.0
   
   # Push tag to GitHub
   git push origin v1.0.0
   ```

2. **GitHub Creates Release Automatically**
   - Go to: **Releases** tab
   - Click on: `v1.0.0` release
   - ISOs are automatically attached!

3. **Download from Releases**
   - Go to: https://github.com/YOUR-USERNAME/CrocLinux/releases
   - Click on: `v1.0.0`
   - Download: ISO files directly

---

## 📥 Part 4: Download ISO from GitHub

### Method 1: Download from Releases (Recommended)
1. **Go to Releases Page**
   - Visit: https://github.com/YOUR-USERNAME/CrocLinux/releases
   - Click on: Latest release (e.g., `v1.0.0`)

2. **Download ISO**
   - Find: `CrocLinux-full-YYYYMMDD.iso` (4-5 GB)
   - Click: Download button
   - Save to: Your Downloads folder

3. **Download Checksums** (Optional but Recommended)
   - Download: `sha256sums.txt`
   - Verify: `sha256sum -c sha256sums.txt`

### Method 2: Download from Artifacts
1. **Go to Actions Tab**
   - Visit: https://github.com/YOUR-USERNAME/CrocLinux/actions
   - Click on: Latest successful workflow run

2. **Download Artifacts**
   - Scroll to: **Artifacts** section
   - Click: **croclinux-isos**
   - Download: ZIP file
   - Extract: ISO files

---

## 💻 Part 5: Use ISO in VirtualBox

### Step 1: Download and Install VirtualBox
1. **Download VirtualBox**
   - Visit: https://www.virtualbox.org/wiki/Downloads
   - Download: VirtualBox for your OS (macOS/Windows/Linux)
   - Install: Follow installation wizard

2. **Verify Installation**
   - Open: VirtualBox
   - Should see: Empty VirtualBox Manager window

### Step 2: Create New Virtual Machine
1. **Click New**
   - Click: **New** button (top-left)
   - Or: **Machine** → **New**

2. **Configure VM Settings**
   - **Name**: `CrocLinux`
   - **Type**: `Linux`
   - **Version**: `Debian (64-bit)`
   - Click: **Next**

3. **Set Memory**
   - **RAM**: `4096 MB` (4 GB) or more
   - **Recommended**: 8192 MB (8 GB)
   - Click: **Next**

4. **Create Virtual Hard Disk**
   - Select: **Create a virtual hard disk now**
   - Click: **Create**

5. **Configure Hard Disk**
   - **File type**: `VDI (VirtualBox Disk Image)`
   - Click: **Next**
   - **Storage**: `Dynamically allocated`
   - Click: **Next**
   - **Size**: `60 GB` (or more)
   - Click: **Create**

### Step 3: Attach ISO to VM
1. **Select VM**
   - Click on: `CrocLinux` VM (left sidebar)

2. **Open Settings**
   - Click: **Settings** button (top menu)
   - Or: Right-click VM → **Settings**

3. **Attach ISO**
   - Click: **Storage** (left sidebar)
   - Click: **Empty** under Controller: IDE
   - Click: **Optical Drive** icon (CD icon)
   - Click: **Choose disk file**
   - Navigate to: Your downloaded ISO file
   - Select: `CrocLinux-full-YYYYMMDD.iso`
   - Click: **Open**
   - Click: **OK**

### Step 4: Configure VM (Optional but Recommended)
1. **System Settings**
   - **Settings** → **System** → **Processor**
   - **Processors**: `2` or more
   - Check: **Enable PAE/NX**
   - Click: **OK**

2. **Display Settings**
   - **Settings** → **Display**
   - **Video Memory**: `128 MB` or more
   - **Graphics Controller**: `VBoxSVGA`
   - Click: **OK**

### Step 5: Start VM and Install
1. **Start VM**
   - Select: `CrocLinux` VM
   - Click: **Start** button (top menu)
   - Or: Double-click VM

2. **Boot Menu Appears**
   - You'll see: CrocLinux boot menu
   - Select: **Install CrocLinux**
   - Press: **Enter**

3. **Follow Installation Wizard**
   - **Language**: English
   - **Locale**: en_US.UTF-8
   - **Keyboard**: US
   - **Hostname**: `croc-soc` (or your choice)
   - **Domain**: Leave blank or enter your domain
   - **Full Name**: `SOC Analyst`
   - **Username**: `analyst`
   - **Password**: `Croc!2025` (change later!)
   - **Partitioning**: **Guided - use entire disk**
   - **Confirm**: Write changes to disk
   - **Software**: Leave defaults
   - **GRUB**: Install GRUB boot loader

4. **Wait for Installation**
   - Installation takes: **20-30 minutes**
   - Progress bar shows: Installation progress
   - **DO NOT** close VM window

5. **Installation Complete**
   - Message: "Installation complete"
   - Click: **Continue**
   - Remove: ISO from VM (Settings → Storage → Remove disk)
   - Reboot: VM restarts automatically

### Step 6: First Boot
1. **VM Reboots**
   - CrocLinux boots from hard disk
   - Login screen appears

2. **Login**
   - **Username**: `analyst`
   - **Password**: `Croc!2025`
   - Press: **Enter**

3. **Desktop Appears**
   - CrocLinux desktop loads
   - You'll see: Desktop shortcuts and menu

4. **Change Password** (Important!)
   ```bash
   # Open terminal: Press Ctrl+Alt+T
   # Or: Applications → System → Terminal
   
   # Change password
   passwd
   
   # Enter current: Croc!2025
   # Enter new password twice
   ```

---

## 🚀 Part 6: Start Using CrocLinux

### Step 1: Access Tools
1. **Via Menu**
   - Click: **Applications** (top-left)
   - Click: **Blue Team**
   - Select: Tool category
   - Click: Tool name

2. **Via Desktop**
   - Click: Desktop shortcuts
   - Example: **CrocSec Dashboard**

3. **Via Terminal**
   ```bash
   # Open terminal: Ctrl+Alt+T
   
   # Check services
   croc-wazuh status
   croc-suricata status
   croc-snort status
   
   # Use CrocSec CLI
   crocsec summary
   crocsec status
   ```

### Step 2: Access Web Interfaces
1. **Open Web Browser**
   - Click: **Applications** → **Web Browser**
   - Or: Press `Alt+F2`, type `firefox`, press Enter

2. **Navigate to Services**
   - **Kibana**: https://127.0.0.1:5601
   - **Wazuh**: https://127.0.0.1:5601/app/wazuh
   - **MISP**: https://127.0.0.1
   - **TheHive**: http://127.0.0.1:9000

3. **Accept SSL Warnings**
   - Click: **Advanced**
   - Click: **Accept Risk** (self-signed certificates)

4. **Login**
   - **Kibana**: `elastic` / `CHANGEME`
   - **MISP**: `admin@croc.local` / `Croc!2025`

### Step 3: Update System
```bash
# Update package list
sudo apt update

# Upgrade system
sudo apt upgrade -y

# Update detection rules
sudo croc-update-rules
```

---

## 📊 Part 7: Verify Everything Works

### Check Services
```bash
# Check Wazuh
croc-wazuh status

# Check Suricata
croc-suricata status

# Check Snort
croc-snort status

# Check all services
sudo systemctl status wazuh-manager elasticsearch kibana suricata snort
```

### Access Dashboards
1. **Kibana Dashboard**
   - URL: https://127.0.0.1:5601
   - Login: `elastic` / `CHANGEME`
   - View: CrocSec Threat Correlation dashboard

2. **Wazuh Console**
   - URL: https://127.0.0.1:5601/app/wazuh
   - View: Security events and alerts

### Test Tools
```bash
# Test Wazuh
croc-wazuh test

# Test Suricata
croc-suricata test-config

# Test Snort
croc-snort test-config
```

---

## 🔄 Part 8: Update and Maintain

### Update ISOs
1. **Make Changes**
   - Edit files locally
   - Commit changes: `git commit -am "Update description"`
   - Push: `git push origin main`

2. **Rebuild ISOs**
   - Go to: **Actions** → **Build CrocLinux ISO**
   - Run workflow again
   - Download: New ISOs

### Create New Release
```bash
# Create new version tag
git tag v1.1.0

# Push tag
git push origin v1.1.0

# GitHub automatically creates release with ISOs
```

---

## 🆘 Troubleshooting

### GitHub Issues

**Problem: Can't push to GitHub**
```bash
# Check remote
git remote -v

# Re-add remote if needed
git remote remove origin
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git
git push -u origin main
```

**Problem: Build fails in GitHub Actions**
- Check: Actions log for errors
- Verify: All files are committed
- Fix: Errors shown in log
- Re-run: Workflow

### VirtualBox Issues

**Problem: VM won't start**
- Check: ISO is attached (Settings → Storage)
- Verify: ISO file is not corrupted
- Try: Different ISO file
- Check: VirtualBox version (update if needed)

**Problem: Installation fails**
- Increase: VM RAM (8+ GB)
- Increase: VM disk size (100+ GB)
- Check: Disk space on host
- Try: Different installation method

**Problem: Services won't start**
```bash
# Check service status
sudo systemctl status wazuh-manager

# Check logs
sudo journalctl -u wazuh-manager -f

# Restart service
sudo systemctl restart wazuh-manager
```

---

## ✅ Quick Reference

### GitHub Commands
```bash
# Initial setup
git init
git add .
git commit -m "Initial release"
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git
git push -u origin main

# Create release
git tag v1.0.0
git push origin v1.0.0
```

### VirtualBox Steps
1. Download VirtualBox
2. Create VM (Linux, Debian 64-bit, 4 GB RAM, 60 GB disk)
3. Attach ISO (Settings → Storage)
4. Start VM
5. Install CrocLinux
6. Login: `analyst` / `Croc!2025`

### Quick Commands
```bash
# Management
croc-wazuh status
croc-suricata status
croc-snort status

# Logs
croc-wazuh logs
croc-suricata logs
croc-snort logs
```

---

## 🎉 Success Checklist

After completing all steps, you should have:
- [x] CrocLinux repository on GitHub
- [x] ISO images built and available
- [x] GitHub Releases with ISOs
- [x] VirtualBox VM running CrocLinux
- [x] All services working
- [x] Web interfaces accessible
- [x] Tools accessible via menu

---

## 📚 Next Steps

1. **Customize**: Adjust theme and settings
2. **Configure**: Set up Wazuh, MISP, TheHive
3. **Test**: Verify all tools work
4. **Share**: Announce to security community
5. **Maintain**: Regular updates and improvements

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Need Help?** See [Step-by-Step Guide](STEP-BY-STEP-GUIDE.md) or [Complete Guide](complete-guide.md)

