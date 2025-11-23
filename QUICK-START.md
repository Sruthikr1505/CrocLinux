# CrocLinux Quick Start - Publish & Use in 5 Steps

## 🚀 Fastest Way to Publish and Use CrocLinux

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
5. Download: ISOs from Artifacts or Releases

### Step 3: Download ISO (2 minutes)
1. Go to: https://github.com/YOUR-USERNAME/CrocLinux/releases
2. Download: `CrocLinux-full-YYYYMMDD.iso`
3. Save to: Downloads folder

### Step 4: Create VirtualBox VM (5 minutes)
1. Open: VirtualBox
2. Click: **New**
3. Name: `CrocLinux`, Type: `Linux`, Version: `Debian (64-bit)`
4. RAM: `4096 MB`, Disk: `60 GB`
5. Settings → Storage → Attach ISO
6. Click: **Start**

### Step 5: Install & Use (20 minutes)
1. Select: **Install CrocLinux** from boot menu
2. Follow: Installation wizard
3. Login: `analyst` / `Croc!2025`
4. Change password: `passwd`
5. Access tools: **Applications** → **Blue Team** menu

**Done!** You're now using CrocLinux in VirtualBox!

---

**Full Guide**: See [GitHub Publish & Use Guide](docs/GITHUB-PUBLISH-AND-USE.md)

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

