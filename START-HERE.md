# 🐊 CrocLinux - Start Here!

## 🎯 What You Want to Do

### I want to publish CrocLinux on GitHub and use it in VirtualBox

**👉 Follow This Guide**: [GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)

This guide shows you:
1. How to publish CrocLinux to GitHub
2. How to build ISO images automatically
3. How to download ISO from GitHub
4. How to setup VirtualBox
5. How to install and use CrocLinux

---

## 📋 Quick 5-Step Process

### Step 1: Publish to GitHub (5 minutes)
```bash
cd "/Users/sruthikr/Desktop/Croc Linux "
git init
git add .
git commit -m "Initial CrocLinux release"
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git
git push -u origin main
```

### Step 2: Build ISO (30-60 minutes)
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux/actions
2. Click: **Build CrocLinux ISO** → **Run workflow**
3. Choose: `both` (full + mini)
4. Wait: 30-60 minutes
5. Download: ISOs from Artifacts

### Step 3: Download ISO (2 minutes)
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux/releases
2. Download: `CrocLinux-full-YYYYMMDD.iso`

### Step 4: Setup VirtualBox (10 minutes)
1. Install: VirtualBox from https://www.virtualbox.org
2. Create VM: Linux, Debian 64-bit, 4 GB RAM, 60 GB disk
3. Attach ISO: Settings → Storage → Choose disk file

### Step 5: Install & Use (20 minutes)
1. Start VM → Select "Install CrocLinux"
2. Follow installation wizard
3. Login: `analyst` / `Croc!2025`
4. Change password: `passwd`
5. Access tools: **Applications** → **Blue Team** menu

**Done!** You're using CrocLinux in VirtualBox!

---

## 📚 Complete Guides

### For Publishing & Using
- **[GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)** - Complete guide from GitHub to VirtualBox
- **[Publish to VirtualBox](docs/PUBLISH-TO-VIRTUALBOX.md)** - Visual step-by-step guide
- **[Step-by-Step Guide](docs/STEP-BY-STEP-GUIDE.md)** - Detailed instructions for everything

### For Using CrocLinux
- **[Quick Reference](docs/QUICK-REFERENCE.md)** - Essential commands and URLs
- **[Usage Guide](docs/usage-guide.md)** - How to use all tools
- **[Wazuh, Snort & Suricata Guide](docs/wazuh-snort-suricata-guide.md)** - Core security tools

### For Building
- **[Build Instructions](docs/build-instructions.md)** - How to build ISOs
- **[VM Image Creation](docs/vm-image-creation.md)** - Create VM images

---

## 🎯 What's Included

### Core Security Tools
- **Wazuh SIEM**: Complete SIEM/XDR platform
- **Suricata IDS/IPS**: Network intrusion detection
- **Snort IDS**: Network intrusion detection
- **50+ Tools**: All pre-configured and ready

### Management Commands
```bash
croc-wazuh status      # Check Wazuh
croc-suricata status   # Check Suricata
croc-snort status      # Check Snort
crocsec summary        # Get overview
```

### Web Interfaces
- **Kibana**: https://127.0.0.1:5601
- **Wazuh**: https://127.0.0.1:5601/app/wazuh
- **MISP**: https://127.0.0.1

---

## ✅ Verification

Before starting, verify your setup:
```bash
cd "/Users/sruthikr/Desktop/Croc Linux "
./scripts/verify-setup.sh
```

**Expected**: ✅ All checks passed!

---

## 🆘 Need Help?

- **Complete Guide**: [GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)
- **Troubleshooting**: See guide for common issues
- **Documentation**: Check `docs/` directory

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Start Now**: [GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)

