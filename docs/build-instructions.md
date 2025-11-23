# CrocLinux Build Instructions

## Option 1: Automated Build via GitHub Actions (Recommended)

**No local Linux VM required!** Build CrocLinux ISOs automatically in the cloud.

### Steps:

1. **Push your code to GitHub**
   ```bash
   git add .
   git commit -m "Prepare for ISO build"
   git push origin main
   ```

2. **Trigger the build workflow**
   - Go to your GitHub repository
   - Click **Actions** tab
   - Select **Build CrocLinux ISO** workflow
   - Click **Run workflow**
   - Choose variant: `full`, `mini`, or `both`
   - Click **Run workflow** button

3. **Wait for build to complete** (30-60 minutes)
   - Watch the progress in the Actions tab
   - Build runs on Ubuntu 22.04 automatically

4. **Download artifacts**
   - When build completes, go to the workflow run
   - Click **croclinux-isos** under Artifacts
   - Download the ISO files and checksums

5. **For releases (optional)**
   - Create a git tag: `git tag v1.0.0 && git push origin v1.0.0`
   - The workflow automatically creates a GitHub Release with ISOs attached
   - Download from the Releases page

## Option 2: Local Build on Linux

If you prefer building locally on a Linux machine:

### Prerequisites (Debian/Ubuntu)

```bash
sudo apt-get update
sudo apt-get install -y live-build debootstrap xorriso squashfs-tools
```

### Build Steps

1. **Clone or copy the project**
   ```bash
   cd /path/to/CrocLinux
   ```

2. **Build ISO variants**
   ```bash
   # Make script executable
   chmod +x scripts/build/build_iso_variant.sh
   
   # Build full ISO
   ./scripts/build/build_iso_variant.sh full
   
   # Build mini ISO
   ./scripts/build/build_iso_variant.sh mini
   ```

3. **Find your ISOs**
   - Output: `release/CrocLinux-full-YYYYMMDD.iso`
   - Output: `release/CrocLinux-mini-YYYYMMDD.iso`
   - Checksums: `release/sha256sums.txt`, `release/sha512sums.txt`

## Option 3: Build in Linux VM (macOS/Windows)

If you're on macOS or Windows and want to build locally:

1. **Install VirtualBox/VMware/Parallels**

2. **Create Ubuntu 22.04 VM**
   - Allocate 8+ GB RAM
   - Allocate 100+ GB disk space
   - Enable virtualization extensions

3. **Copy project into VM**
   - Use shared folders or `git clone` inside VM
   - Or use `scp` to transfer files

4. **Follow Option 2 steps** inside the Linux VM

## Build Requirements

- **OS:** Debian/Ubuntu Linux (for local builds)
- **RAM:** 8 GB minimum (16 GB recommended)
- **Disk:** 100+ GB free space
- **Time:** 30-60 minutes per ISO variant
- **Internet:** Required for downloading packages during build

## Troubleshooting

### GitHub Actions build fails
- Check the Actions log for error messages
- Ensure all required files are committed
- Verify package lists exist in `build/iso/config/package-lists/`

### Local build fails with permission errors
- Ensure you're using `sudo` for `lb` commands
- Check disk space: `df -h`
- Verify internet connection for package downloads

### ISO won't boot
- Verify checksums match: `sha256sum -c sha256sums.txt`
- Test ISO in VirtualBox before burning to USB
- Ensure UEFI/BIOS settings are correct

## Next Steps After Building

1. **Test the ISO** in VirtualBox/VMware
2. **Update `release/links.txt`** with download URLs
3. **Create GitHub Release** (if using automated builds)
4. **Share download links** with users

> **Tip:** GitHub Actions is the easiest method - no setup required, builds happen automatically in the cloud!
