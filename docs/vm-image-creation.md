# CrocLinux VM Image Creation Guide

## Overview
This guide explains how to create pre-built VM images (OVA, VMDK) for CrocLinux - similar to Kali Linux's VM images.

## Automated Creation (Recommended)

### Using Packer (Automated)
**Easiest method** - Automatically creates VM images:

1. **Install Packer**
   ```bash
   # macOS
   brew install packer
   
   # Linux
   wget https://releases.hashicorp.com/packer/1.10.0/packer_1.10.0_linux_amd64.zip
   unzip packer_1.10.0_linux_amd64.zip
   sudo mv packer /usr/local/bin/
   ```

2. **Build VM Images**
   ```bash
   cd scripts/build/packer
   packer init .
   packer build -var "iso_file=../../release/CrocLinux-full-YYYYMMDD.iso" croclinux.pkr.hcl
   ```

3. **Output**
   - OVA files created in `release/vm-build/`
   - Ready to import into VirtualBox/VMware

### Using GitHub Actions (Automated)
**No setup required!** VM images are built automatically:

1. Create a release tag: `git tag v1.0.0 && git push origin v1.0.0`
2. GitHub Actions builds ISOs and VM images automatically
3. Download OVA files from Releases page

## Manual Creation (VirtualBox)

### Step 1: Create VM
1. Open VirtualBox
2. Click **New**
3. Name: `CrocLinux`
4. Type: `Linux`
5. Version: `Debian (64-bit)`
6. Memory: 4096 MB
7. Hard disk: 60+ GB (dynamically allocated)

### Step 2: Install CrocLinux
1. Attach ISO: Settings → Storage → Empty CD → Select ISO
2. Start VM
3. Select "Install CrocLinux"
4. Follow installation wizard
5. Login: `analyst` / `Croc!2025`

### Step 3: Post-Install Configuration
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Run post-install scripts
sudo /opt/croc/scripts/base/prepare_system.sh
sudo /opt/croc/scripts/base/hardening.sh
sudo /opt/croc/scripts/services/install_blue_team_stack.sh
sudo /opt/croc/scripts/automation/setup_integrations.sh

# Clean up
sudo apt clean
sudo rm -rf /tmp/*
sudo rm -f /var/log/*.log
```

### Step 4: Prepare for Export
```bash
# Zero out free space (reduces image size)
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

# Shutdown VM
sudo shutdown -h now
```

### Step 5: Export OVA
1. Select VM in VirtualBox
2. Click **File** → **Export Appliance**
3. Select VM
4. Choose format: **Open Virtualization Format 2.0 (OVA)**
5. Export to `CrocLinux-v1.0.0.ova`
6. Click **Export**

## Manual Creation (VMware)

### Step 1: Create VM
1. Open VMware Workstation/Fusion
2. Click **Create a New Virtual Machine**
3. Select "Typical"
4. Choose "I will install the operating system later"
5. Select **Linux** → **Debian 12.x 64-bit**
6. Name: `CrocLinux`
7. Disk: 60+ GB
8. Memory: 4096 MB

### Step 2: Install CrocLinux
1. VM Settings → CD/DVD → Use ISO image file
2. Select CrocLinux ISO
3. Start VM
4. Follow installation wizard
5. Login: `analyst` / `Croc!2025`

### Step 3: Post-Install Configuration
Same as VirtualBox steps above.

### Step 4: Export OVA
1. Select VM in VMware
2. Click **File** → **Export to OVF**
3. Save as `CrocLinux-v1.0.0.ova`
4. Click **Export**

## Testing VM Images

### VirtualBox
1. File → Import Appliance
2. Select OVA file
3. Click Import
4. Start VM
5. Verify login works
6. Check all tools are accessible

### VMware
1. File → Open
2. Select OVA file
3. Click Import
4. Play VM
5. Verify login works
6. Check all tools are accessible

## Publishing VM Images

### GitHub Releases
1. Create release tag: `git tag v1.0.0 && git push origin v1.0.0`
2. GitHub Actions automatically builds and uploads VM images
3. Download from Releases page

### Manual Upload
1. Go to GitHub Releases page
2. Click **Edit** on release
3. Drag and drop OVA files
4. Add release notes
5. Click **Update release**

## File Sizes

| Format | Typical Size | Notes |
|--------|--------------|-------|
| Full ISO | 4-5 GB | Complete installation |
| Mini ISO | 2-3 GB | Lightweight version |
| OVA (Full) | 8-12 GB | Compressed VM image |
| OVA (Mini) | 4-6 GB | Compressed VM image |

## Troubleshooting

### VM image is too large
- Zero out free space before export
- Remove unnecessary packages
- Compress OVA file: `tar -czf CrocLinux.ova.tar.gz CrocLinux.ova`

### VM won't boot
- Verify OVA file integrity
- Check VM settings (memory, CPU)
- Try importing into different VM software

### Tools are missing
- Verify post-install scripts ran successfully
- Check `/opt/croc/scripts/` directory
- Review installation logs

## Best Practices

1. **Always verify VM images** before publishing
2. **Test on multiple platforms** (VirtualBox, VMware)
3. **Update default passwords** in post-install scripts
4. **Document known issues** in release notes
5. **Provide checksums** for all VM images

## Next Steps

After creating VM images:
1. Test on VirtualBox and VMware
2. Verify all tools work correctly
3. Generate checksums
4. Upload to GitHub Releases
5. Update `release/links.txt` with download URLs

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

