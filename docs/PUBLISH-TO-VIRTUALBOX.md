# Publish CrocLinux to GitHub & Use in VirtualBox - Visual Guide

## 📊 Complete Flow Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    STEP 1: PREPARE                         │
│  cd "/Users/sruthikr/Desktop/Croc Linux "                  │
│  ./scripts/verify-setup.sh                                  │
│  ✅ Verify all files are ready                              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              STEP 2: PUBLISH TO GITHUB                      │
│                                                              │
│  A. Create GitHub Repository                                │
│     → Go to: https://github.com/new                         │
│     → Name: CrocLinux                                       │
│     → Create repository                                     │
│                                                              │
│  B. Push Code                                               │
│     → git init                                              │
│     → git add .                                             │
│     → git commit -m "Initial release"                       │
│     → git remote add origin https://github.com/...         │
│     → git push -u origin main                               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│            STEP 3: BUILD ISO (GitHub Actions)                │
│                                                              │
│  A. Trigger Build                                           │
│     → Go to: Actions tab                                    │
│     → Click: Build CrocLinux ISO                            │
│     → Run workflow → Choose: both                           │
│                                                              │
│  B. Wait for Build                                          │
│     → Wait: 30-60 minutes                                    │
│     → Status: Green = Success                               │
│                                                              │
│  C. Download ISO                                            │
│     → Click: Artifacts → croclinux-isos                     │
│     → Download: ZIP file                                    │
│     → Extract: ISO files                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              STEP 4: DOWNLOAD ISO                            │
│                                                              │
│  Option A: From Releases (Recommended)                      │
│     → Go to: Releases tab                                   │
│     → Click: Latest release                                 │
│     → Download: CrocLinux-full-YYYYMMDD.iso                │
│                                                              │
│  Option B: From Artifacts                                   │
│     → Go to: Actions → Latest run                           │
│     → Download: Artifacts ZIP                               │
│     → Extract: ISO files                                    │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│         STEP 5: SETUP VIRTUALBOX                            │
│                                                              │
│  A. Install VirtualBox                                      │
│     → Download: https://www.virtualbox.org                  │
│     → Install: Follow wizard                                │
│                                                              │
│  B. Create VM                                               │
│     → Click: New                                            │
│     → Name: CrocLinux                                       │
│     → Type: Linux, Debian (64-bit)                          │
│     → RAM: 4096 MB (4 GB)                                   │
│     → Disk: 60 GB                                           │
│                                                              │
│  C. Attach ISO                                               │
│     → Settings → Storage                                     │
│     → Empty CD → Choose disk file                           │
│     → Select: CrocLinux-full-YYYYMMDD.iso                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│         STEP 6: INSTALL CROCLINUX                           │
│                                                              │
│  A. Start VM                                                │
│     → Click: Start button                                   │
│     → Boot menu appears                                     │
│                                                              │
│  B. Install                                                 │
│     → Select: Install CrocLinux                             │
│     → Follow: Installation wizard                           │
│     → Username: analyst                                     │
│     → Password: Croc!2025                                   │
│     → Wait: 20-30 minutes                                   │
│                                                              │
│  C. First Boot                                              │
│     → Remove ISO                                            │
│     → Reboot                                                │
│     → Login: analyst / Croc!2025                           │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│            STEP 7: USE CROCLINUX                             │
│                                                              │
│  A. Change Password                                         │
│     → Open terminal: Ctrl+Alt+T                             │
│     → Run: passwd                                           │
│                                                              │
│  B. Access Tools                                            │
│     → Applications → Blue Team menu                         │
│     → Or: Desktop shortcuts                                │
│                                                              │
│  C. Access Web Interfaces                                   │
│     → Kibana: https://127.0.0.1:5601                        │
│     → Wazuh: https://127.0.0.1:5601/app/wazuh              │
│     → MISP: https://127.0.0.1                               │
└─────────────────────────────────────────────────────────────┘
```

---

## 📝 Detailed Step-by-Step

### ✅ Step 1: Verify Setup (2 minutes)
```bash
cd "/Users/sruthikr/Desktop/Croc Linux "
./scripts/verify-setup.sh
```
**Result**: ✅ All checks passed!

---

### ✅ Step 2: Create GitHub Repository (5 minutes)

#### A. Create Repository on GitHub
1. Go to: https://github.com/new
2. Repository name: `CrocLinux`
3. Description: `CrocLinux — The Silent Guardian of Cyber Defense`
4. Public or Private: Your choice
5. **DO NOT** check "Initialize with README"
6. Click: **Create repository**

#### B. Push Code to GitHub
```bash
# Initialize git (if not done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial CrocLinux release - Complete Blue Team distribution"

# Add remote (replace YOUR-USERNAME)
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git

# Push to GitHub
git push -u origin main
```

**If authentication required:**
- Use GitHub Personal Access Token
- Create: GitHub → Settings → Developer settings → Personal access tokens
- Token: `repo` scope

**Result**: Code is on GitHub!

---

### ✅ Step 3: Build ISO Images (30-60 minutes)

#### A. Trigger GitHub Actions Build
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux
2. Click: **Actions** tab
3. Click: **Build CrocLinux ISO** workflow
4. Click: **Run workflow** button (top right)
5. Select variant: `both` (builds full + mini)
6. Click: **Run workflow** button

#### B. Monitor Build
1. Click on: Running workflow
2. Watch: Build progress
3. Wait: 30-60 minutes
4. Status changes: Yellow (running) → Green (success)

#### C. Download ISOs
**From Artifacts:**
1. Go to: Completed workflow run
2. Scroll to: **Artifacts** section
3. Click: **croclinux-isos**
4. Download: ZIP file
5. Extract: ISO files

**From Releases (after creating tag):**
1. Create tag: `git tag v1.0.0 && git push origin v1.0.0`
2. Go to: **Releases** tab
3. Click: `v1.0.0` release
4. Download: ISO files directly

**Result**: ISO files ready!

---

### ✅ Step 4: Download ISO (2 minutes)

#### Option A: From Releases (Easiest)
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux/releases
2. Click on: Latest release
3. Download: `CrocLinux-full-YYYYMMDD.iso` (4-5 GB)
4. Save to: Downloads folder

#### Option B: From Artifacts
1. Go to: Actions → Latest successful run
2. Download: Artifacts ZIP
3. Extract: ISO files

**Result**: ISO file downloaded!

---

### ✅ Step 5: Setup VirtualBox (10 minutes)

#### A. Install VirtualBox
1. Download: https://www.virtualbox.org/wiki/Downloads
2. Install: Follow installation wizard
3. Open: VirtualBox

#### B. Create Virtual Machine
1. Click: **New** button
2. **Name**: `CrocLinux`
3. **Type**: `Linux`
4. **Version**: `Debian (64-bit)`
5. Click: **Next**
6. **Memory**: `4096 MB` (4 GB) or `8192 MB` (8 GB recommended)
7. Click: **Next**
8. **Hard disk**: Create virtual hard disk now
9. Click: **Create**
10. **File type**: `VDI (VirtualBox Disk Image)`
11. Click: **Next**
12. **Storage**: `Dynamically allocated`
13. Click: **Next**
14. **Size**: `60 GB` (or more)
15. Click: **Create**

#### C. Attach ISO
1. Select: `CrocLinux` VM
2. Click: **Settings**
3. Click: **Storage** (left sidebar)
4. Click: **Empty** under Controller: IDE
5. Click: **Optical Drive** icon (CD icon)
6. Click: **Choose disk file**
7. Navigate to: Your Downloads folder
8. Select: `CrocLinux-full-YYYYMMDD.iso`
9. Click: **Open**
10. Click: **OK**

**Result**: VM ready with ISO attached!

---

### ✅ Step 6: Install CrocLinux (20-30 minutes)

#### A. Start VM
1. Select: `CrocLinux` VM
2. Click: **Start** button
3. VM window opens
4. Boot menu appears

#### B. Install
1. Select: **Install CrocLinux** from boot menu
2. Press: **Enter**
3. Follow installation wizard:
   - **Language**: English → **Continue**
   - **Locale**: en_US.UTF-8 → **Continue**
   - **Keyboard**: US → **Continue**
   - **Hostname**: `croc-soc` → **Continue**
   - **Domain**: (leave blank) → **Continue**
   - **Full Name**: `SOC Analyst` → **Continue**
   - **Username**: `analyst` → **Continue**
   - **Password**: `Croc!2025` → **Continue**
   - **Confirm Password**: `Croc!2025` → **Continue**
   - **Partitioning**: **Guided - use entire disk** → **Continue**
   - **Confirm**: Write changes to disk → **Continue**
   - **Software**: Leave defaults → **Continue**
   - **GRUB**: Install GRUB boot loader → **Continue**

4. Wait: 20-30 minutes for installation
5. **DO NOT** close VM window during installation

#### C. Complete Installation
1. Message: "Installation complete"
2. Click: **Continue**
3. Remove ISO:
   - **Settings** → **Storage** → **Remove disk from virtual drive**
4. VM reboots automatically
5. CrocLinux boots from hard disk

**Result**: CrocLinux installed!

---

### ✅ Step 7: First Boot & Use (5 minutes)

#### A. Login
1. Login screen appears
2. **Username**: `analyst`
3. **Password**: `Croc!2025`
4. Press: **Enter**
5. Desktop loads

#### B. Change Password (Critical!)
1. Open terminal: Press `Ctrl+Alt+T`
2. Run: `passwd`
3. Enter: Current password (`Croc!2025`)
4. Enter: New password (twice)
5. **Done!**

#### C. Access Tools
**Via Menu:**
1. Click: **Applications** (top-left)
2. Click: **Blue Team**
3. Select: Tool category
4. Click: Tool name

**Via Desktop:**
- Click: Desktop shortcuts
- Example: **CrocSec Dashboard**

**Via Terminal:**
```bash
# Check services
croc-wazuh status
croc-suricata status
croc-snort status

# Use CrocSec CLI
crocsec summary
crocsec status
```

#### D. Access Web Interfaces
1. Open: Web browser
2. Navigate to:
   - **Kibana**: https://127.0.0.1:5601
   - **Wazuh**: https://127.0.0.1:5601/app/wazuh
   - **MISP**: https://127.0.0.1
3. Accept: SSL warnings (self-signed certificates)
4. Login: Use default credentials (change later!)

**Result**: CrocLinux is ready to use!

---

## 🎯 Quick Command Reference

### GitHub Commands
```bash
git init
git add .
git commit -m "Initial release"
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git
git push -u origin main
git tag v1.0.0
git push origin v1.0.0
```

### CrocLinux Commands
```bash
# Management
croc-wazuh status
croc-suricata status
croc-snort status

# Logs
croc-wazuh logs
croc-suricata logs
croc-snort logs

# CrocSec CLI
crocsec summary
crocsec status
crocsec update_rules
```

---

## ✅ Success Checklist

After completing all steps:
- [x] Repository on GitHub
- [x] ISO images built
- [x] ISO downloaded
- [x] VirtualBox installed
- [x] VM created
- [x] ISO attached
- [x] CrocLinux installed
- [x] First boot successful
- [x] Password changed
- [x] Tools accessible
- [x] Web interfaces working

---

## 🆘 Common Issues & Solutions

### GitHub: Can't Push
```bash
# Check remote
git remote -v

# Re-add if needed
git remote remove origin
git remote add origin https://github.com/YOUR-USERNAME/CrocLinux.git
git push -u origin main
```

### VirtualBox: VM Won't Start
- Check: ISO is attached (Settings → Storage)
- Verify: ISO file integrity
- Try: Different ISO file
- Update: VirtualBox to latest version

### Installation: Fails
- Increase: VM RAM to 8 GB
- Increase: VM disk to 100 GB
- Check: Host disk space
- Try: Different installation method

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Full Guide**: [GitHub Publish & Use Guide](GITHUB-PUBLISH-AND-USE.md)

