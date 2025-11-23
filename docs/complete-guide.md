# CrocLinux Complete Guide

## Overview
This comprehensive guide covers everything you need to know about CrocLinux: publishing, downloading, virtualizing, using, and customizing the theme.

## 📦 Publishing CrocLinux

### Step 1: Prepare Repository
1. Initialize Git repository
2. Create GitHub repository
3. Push code to GitHub

### Step 2: Create Release
1. Trigger GitHub Actions workflow
2. Wait for build (30-60 minutes)
3. Create release tag: `git tag v1.0.0 && git push origin v1.0.0`
4. GitHub Actions automatically creates release with ISOs and VM images

### Step 3: Update Links
1. Get release URLs from GitHub Releases page
2. Update `release/links.txt` with actual URLs
3. Update README with download links
4. Commit and push changes

**Full Guide**: See [Publishing Guide](publishing-guide.md)

## 📥 Downloading CrocLinux

### Option 1: ISO Images
1. Go to GitHub Releases page
2. Download `CrocLinux-full-YYYYMMDD.iso` or `CrocLinux-mini-YYYYMMDD.iso`
3. Verify checksums: `sha256sum -c sha256sums.txt`
4. Create bootable USB or use in VM

### Option 2: VM Images (Easiest!)
1. Go to GitHub Releases page
2. Download `CrocLinux-v1.0.0.ova`
3. Import into VirtualBox/VMware
4. Start VM and login: `analyst` / `Croc!2025`

**Full Guide**: See [Download Guide](download-guide.md)

## 💻 Virtualizing CrocLinux

### VirtualBox (Recommended)
1. **Using OVA** (Easiest):
   - Download `CrocLinux-v1.0.0.ova`
   - File → Import Appliance → Select OVA → Import
   - Start VM → Login: `analyst` / `Croc!2025`

2. **Using ISO**:
   - Create new VM (Linux, Debian 64-bit, 4 GB RAM, 60 GB disk)
   - Attach ISO to VM
   - Start VM → Install CrocLinux
   - Follow installation wizard

### VMware
1. **Using OVA** (Easiest):
   - Download `CrocLinux-v1.0.0.ova`
   - File → Open → Select OVA → Import
   - Play VM → Login: `analyst` / `Croc!2025`

2. **Using ISO**:
   - Create new VM (Linux, Debian 12.x 64-bit, 4 GB RAM, 60 GB disk)
   - Attach ISO to VM
   - Start VM → Install CrocLinux
   - Follow installation wizard

### Hyper-V (Windows)
1. Create new VM (Generation 2, 4 GB RAM, 60 GB disk)
2. Attach ISO to VM
3. Start VM → Install CrocLinux
4. Follow installation wizard

**Full Guide**: See [Download & Virtualization Guide](download-virtualization-guide.md)

## 🚀 Using CrocLinux

### First Boot
1. **Login**: `analyst` / `Croc!2025`
2. **Change Password**: `passwd`
3. **Update System**: `sudo apt update && sudo apt upgrade -y`
4. **Start Services**: `sudo systemctl start wazuh-manager elasticsearch kibana`

### Access Tools
1. **Menu**: Click **Applications** → **Blue Team** menu
2. **Web Interfaces**:
   - Kibana: https://127.0.0.1:5601
   - Wazuh: https://127.0.0.1:5601/app/wazuh
   - MISP: https://127.0.0.1
   - TheHive: http://127.0.0.1:9000
   - Cortex: http://127.0.0.1:9001
   - Velociraptor: https://127.0.0.1:8000

3. **CLI**: Use `crocsec` assistant
   ```bash
   crocsec summary
   crocsec status
   crocsec update_rules
   ```

### Common Tasks
- **Update Rules**: `sudo croc-update-rules`
- **Import IOCs**: `sudo croc-ioc-import /path/to/ioc.json`
- **Check Services**: `sudo systemctl status wazuh-manager elasticsearch kibana`
- **View Logs**: `sudo tail -f /var/ossec/logs/alerts/alerts.json`

**Full Guide**: See [Usage Guide](usage-guide.md)

## 🎨 CrocLinux Theme

### Theme Design
- **Dark Background**: #1a1a1a (reduces eye strain)
- **Light Foreground**: #e0e0e0 (high contrast)
- **Blue Accents**: #00a8ff (CrocLinux brand color)
- **JetBrains Mono Font**: Modern, readable monospace font

### Theme Components
- **Desktop**: Dark XFCE desktop with blue accents
- **Terminal**: Dark terminal with blue cursor
- **Login Screen**: CrocLinux branded login screen
- **Menu**: Dark menu with blue highlights

### Customizing Theme
1. **Change Colors**: Edit `/usr/share/themes/CrocLinux/gtk-3.0/gtk.css`
2. **Change Fonts**: Edit `~/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml`
3. **Change Wallpaper**: Use Settings → Desktop → Background
4. **Apply Theme**: Run `sudo /opt/croc/scripts/base/configure_theme.sh`

**Full Guide**: See [Theme Guide](theme-guide.md)

## 📋 Quick Reference

### Default Credentials
- **System**: `analyst` / `Croc!2025`
- **Kibana**: `elastic` / `CHANGEME`
- **Wazuh**: `wazuh` / `CHANGE_ME`
- **MISP**: `admin@croc.local` / `Croc!2025`

### Service Ports
- **Kibana**: 5601
- **Elasticsearch**: 9200
- **Wazuh**: 55000
- **MISP**: 443
- **TheHive**: 9000
- **Cortex**: 9001
- **Velociraptor**: 8000

### Important Files
- **Theme**: `/usr/share/themes/CrocLinux/`
- **Icons**: `/usr/share/icons/CrocLinux/`
- **Wallpaper**: `/usr/share/backgrounds/CrocLinux/`
- **Scripts**: `/opt/croc/scripts/`
- **Logs**: `/var/ossec/logs/`

## 🔧 Troubleshooting

### VM Won't Boot
- Verify ISO file integrity
- Check VM settings (memory, CPU)
- Try different VM software

### Services Won't Start
- Check service status: `sudo systemctl status <service>`
- Check logs: `sudo journalctl -u <service> -f`
- Restart service: `sudo systemctl restart <service>`

### Theme Not Applying
- Check theme files: `ls -la /usr/share/themes/CrocLinux/`
- Verify configuration: `xfconf-query -c xsettings -p /Net/ThemeName`
- Apply theme: `sudo /opt/croc/scripts/base/configure_theme.sh`

## 📚 Additional Resources

- **Publishing**: [Publishing Guide](publishing-guide.md)
- **Download**: [Download Guide](download-guide.md)
- **Virtualization**: [Download & Virtualization Guide](download-virtualization-guide.md)
- **Usage**: [Usage Guide](usage-guide.md)
- **Theme**: [Theme Guide](theme-guide.md)
- **Installation**: [Install Guide](install-guide.md)
- **First Boot**: [First Boot Guide](first-boot.md)

## 🎯 Next Steps

1. **Download**: Get ISO or VM image from GitHub Releases
2. **Virtualize**: Import OVA into VirtualBox/VMware
3. **Use**: Access tools via menu or web interfaces
4. **Customize**: Adjust theme and settings to your preferences
5. **Configure**: Set up Wazuh, MISP, TheHive, and other services

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

**Download Now**: [GitHub Releases](https://github.com/YOUR-USERNAME/CrocLinux/releases)

