# CrocLinux Download & Virtualization Guide

## Overview
This guide explains how to download CrocLinux and run it in a virtual machine (VirtualBox, VMware, Hyper-V) - just like Kali Linux.

## Step 1: Download CrocLinux

### Option 1: Download from GitHub Releases (Recommended)
1. **Go to Releases Page**
   - Visit: https://github.com/YOUR-USERNAME/CrocLinux/releases
   - Click on the latest release (e.g., `v1.0.0`)

2. **Download ISO or VM Image**
   - **ISO Image**: Download `CrocLinux-full-YYYYMMDD.iso` or `CrocLinux-mini-YYYYMMDD.iso`
   - **VM Image (OVA)**: Download `CrocLinux-v1.0.0.ova` (pre-built VM)
   - **Checksums**: Download `sha256sums.txt` and `sha512sums.txt`

3. **Verify Downloads** (Recommended)
   ```bash
   # Verify SHA-256 checksum
   sha256sum -c sha256sums.txt
   
   # Verify SHA-512 checksum
   sha512sum -c sha512sums.txt
   ```

### Option 2: Download from Direct Links
1. **Check Links File**
   - Open `release/links.txt` for download links
   - Use direct download URLs

2. **Download Files**
   ```bash
   # Download ISO
   wget https://github.com/YOUR-USERNAME/CrocLinux/releases/download/v1.0.0/CrocLinux-full-YYYYMMDD.iso
   
   # Download OVA
   wget https://github.com/YOUR-USERNAME/CrocLinux/releases/download/v1.0.0/CrocLinux-v1.0.0.ova
   ```

## Step 2: Virtualize CrocLinux

### Option 1: VirtualBox (Recommended)

#### Using Pre-Built VM Image (OVA) - Easiest!
1. **Download OVA File**
   - Download `CrocLinux-v1.0.0.ova` from Releases page

2. **Import VM**
   - Open VirtualBox
   - Click **File** → **Import Appliance**
   - Select `CrocLinux-v1.0.0.ova`
   - Click **Import**
   - Wait for import to complete

3. **Start VM**
   - Select CrocLinux VM
   - Click **Start**
   - Login: `analyst` / `Croc!2025`

#### Using ISO Image
1. **Create New VM**
   - Open VirtualBox
   - Click **New**
   - Name: `CrocLinux`
   - Type: `Linux`
   - Version: `Debian (64-bit)`
   - Memory: 4096 MB (4 GB) or more
   - Hard disk: 60+ GB (dynamically allocated)
   - Click **Create**

2. **Configure VM**
   - Select VM → **Settings**
   - **System** → **Processor**: 2+ CPUs
   - **Display** → **Video Memory**: 128 MB
   - **Storage** → **Empty CD** → **Choose disk file**
   - Select `CrocLinux-full-YYYYMMDD.iso`
   - Click **OK**

3. **Install CrocLinux**
   - Start VM
   - Select "Install CrocLinux" from boot menu
   - Follow installation wizard
   - Login: `analyst` / `Croc!2025`

### Option 2: VMware (Workstation/Fusion)

#### Using Pre-Built VM Image (OVA) - Easiest!
1. **Download OVA File**
   - Download `CrocLinux-v1.0.0.ova` from Releases page

2. **Import VM**
   - Open VMware Workstation/Fusion
   - Click **File** → **Open**
   - Select `CrocLinux-v1.0.0.ova`
   - Click **Import**
   - Wait for import to complete

3. **Start VM**
   - Select CrocLinux VM
   - Click **Play**
   - Login: `analyst` / `Croc!2025`

#### Using ISO Image
1. **Create New VM**
   - Open VMware Workstation/Fusion
   - Click **Create a New Virtual Machine**
   - Select **Typical**
   - Choose **I will install the operating system later**
   - Select **Linux** → **Debian 12.x 64-bit**
   - Name: `CrocLinux`
   - Disk: 60+ GB
   - Memory: 4096 MB (4 GB)
   - Click **Finish**

2. **Configure VM**
   - Select VM → **Settings**
   - **CD/DVD** → **Use ISO image file**
   - Select `CrocLinux-full-YYYYMMDD.iso`
   - Click **OK**

3. **Install CrocLinux**
   - Start VM
   - Follow installation wizard
   - Login: `analyst` / `Croc!2025`

### Option 3: Hyper-V (Windows)

#### Using ISO Image
1. **Create New VM**
   - Open Hyper-V Manager
   - Click **New** → **Virtual Machine**
   - Name: `CrocLinux`
   - Generation: **Generation 2**
   - Memory: 4096 MB (4 GB)
   - Network: Default Switch
   - Disk: 60+ GB
   - Installation: **Install an operating system from a bootable image file**
   - Select `CrocLinux-full-YYYYMMDD.iso`
   - Click **Finish**

2. **Install CrocLinux**
   - Start VM
   - Follow installation wizard
   - Login: `analyst` / `Croc!2025`

### Option 4: QEMU/KVM (Linux)

#### Using ISO Image
1. **Create VM**
   ```bash
   # Create disk image
   qemu-img create -f qcow2 croclinux.qcow2 60G
   
   # Start VM
   qemu-system-x86_64 \
     -name CrocLinux \
     -m 4096 \
     -cpu host \
     -smp 2 \
     -drive file=croclinux.qcow2,format=qcow2 \
     -cdrom CrocLinux-full-YYYYMMDD.iso \
     -boot d \
     -vga virtio \
     -display sdl
   ```

2. **Install CrocLinux**
   - Follow installation wizard
   - Login: `analyst` / `Croc!2025`

## Step 3: Configure VM

### VirtualBox Settings
- **Memory**: 4+ GB (8 GB recommended)
- **Processors**: 2+ CPUs
- **Video Memory**: 128 MB
- **Network**: NAT or Bridged Adapter
- **Audio**: Disabled (optional)
- **USB**: USB 3.0 (optional)

### VMware Settings
- **Memory**: 4+ GB (8 GB recommended)
- **Processors**: 2+ CPUs
- **Video Memory**: 128 MB
- **Network**: NAT or Bridged
- **Audio**: Disabled (optional)
- **USB**: USB 3.0 (optional)

### Hyper-V Settings
- **Memory**: 4+ GB (8 GB recommended)
- **Processors**: 2+ vCPUs
- **Network**: Default Switch
- **Security**: Secure Boot (disabled for CrocLinux)
- **Checkpoints**: Disabled (optional)

## Step 4: First Boot

### Login
- **Username**: `analyst`
- **Password**: `Croc!2025`

### Change Password
```bash
# Change password immediately
passwd
```

### Update System
```bash
# Update package list
sudo apt update

# Upgrade system
sudo apt upgrade -y
```

### Start Services
```bash
# Check service status
sudo systemctl status wazuh-manager elasticsearch kibana

# Start services if needed
sudo systemctl start wazuh-manager elasticsearch kibana
```

## Step 5: Access Tools

### Web Interfaces
- **Kibana**: https://127.0.0.1:5601
- **Wazuh**: https://127.0.0.1:5601/app/wazuh
- **MISP**: https://127.0.0.1
- **TheHive**: http://127.0.0.1:9000
- **Cortex**: http://127.0.0.1:9001
- **Velociraptor**: https://127.0.0.1:8000

### Menu
- Click **Applications** → **Blue Team** menu
- All tools are organized by category

### CLI
```bash
# CrocSec CLI assistant
crocsec summary
crocsec status
crocsec update_rules
```

## Troubleshooting

### VM Won't Boot
- Verify ISO file integrity
- Check VM settings (memory, CPU)
- Try different VM software
- Check BIOS/UEFI settings

### VM is Slow
- Increase RAM allocation (8+ GB)
- Increase CPU cores (2+)
- Enable hardware acceleration
- Use SSD for VM disk

### Services Won't Start
- Check service status: `sudo systemctl status <service>`
- Check logs: `sudo journalctl -u <service> -f`
- Restart service: `sudo systemctl restart <service>`

### Network Issues
- Check VM network settings
- Verify network adapter is enabled
- Try different network mode (NAT, Bridged)
- Check firewall rules

## Best Practices

### VM Configuration
- Allocate enough resources (RAM, CPU, disk)
- Enable hardware acceleration
- Use SSD for better performance
- Regular backups

### Security
- Change default passwords
- Enable firewall
- Keep system updated
- Monitor logs

### Performance
- Allocate sufficient resources
- Use SSD for VM disk
- Enable hardware acceleration
- Optimize VM settings

## Next Steps

1. **Configure Services**: Set up Wazuh, MISP, TheHive
2. **Import Rules**: Update detection rules
3. **Enroll Agents**: Install Wazuh agents on endpoints
4. **Monitor**: Set up monitoring and alerts

---

**CrocLinux — The Silent Guardian of Cyber Defense** 🐊

