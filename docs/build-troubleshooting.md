# Build Troubleshooting Guide

## Common Build Issues

### Issue: `fatal: repository './config' does not exist`

**Error Message:**
```
fatal: repository './config' does not exist
Error: Process completed with exit code 128.
```

**Cause:**
The `lb config --config ./config` command expects `./config` to be a git repository, but it's just a directory with configuration files.

**Solution:**
The build script has been updated to use the standard live-build workflow:

1. Run `lb config` with parameters to initialize the configuration
2. Copy custom files into the generated `config/` directory
3. Run `lb build` to create the ISO

**Fixed in:** `scripts/build/build_iso_variant.sh`

### Issue: ISO not found after build

**Error Message:**
```
[!] Expected ISO not found
```

**Possible Causes:**
- Build failed silently
- ISO is in a different location than expected
- Permissions issue

**Solution:**
The build script now checks multiple possible ISO locations:
- `binary/live-image-amd64.hybrid.iso` (standard location)
- `live-image-amd64.hybrid.iso` (alternative location)

If neither is found, it will search for any `.iso` files in the build directory.

### Issue: Permission denied errors

**Error Message:**
```
Permission denied: scripts/build/build_iso_variant.sh
```

**Solution:**
Make scripts executable:
```bash
chmod +x scripts/build/build_iso_variant.sh
chmod +x scripts/base/*.sh
chmod +x scripts/services/*.sh
chmod +x scripts/automation/*.sh
```

### Issue: Package list not found

**Error Message:**
```
[!] Package list ... not found
```

**Solution:**
Ensure the package list files exist:
- `build/iso/config/package-lists/croclinux-full.list.chroot`
- `build/iso/config/package-lists/croclinux-mini.list.chroot`

### Issue: Build takes too long

**Expected Behavior:**
ISO builds typically take 30-60 minutes depending on:
- Number of packages
- System resources
- Network speed (for package downloads)

**Tips:**
- Use a machine with at least 8GB RAM
- Ensure stable internet connection
- Use local Debian mirror if possible
- Consider building mini ISO first (faster)

### Issue: Out of disk space

**Error Message:**
```
No space left on device
```

**Solution:**
- Clean previous builds: `sudo lb clean --purge`
- Ensure at least 20GB free disk space
- Use `df -h` to check available space

## GitHub Actions Specific Issues

### Issue: Build fails in GitHub Actions

**Common Causes:**
1. Missing dependencies
2. Incorrect paths
3. Permission issues
4. Timeout (builds can take 1-2 hours)

**Solution:**
- Check the workflow logs for specific errors
- Ensure all required packages are installed in the workflow
- Increase timeout if needed (default is 6 hours)

### Issue: Artifacts not uploaded

**Solution:**
- Ensure `release/` directory exists before build
- Check that ISO files are created successfully
- Verify artifact upload step in workflow

## Local Build Issues

### Issue: Cannot run lb commands

**Error Message:**
```
lb: command not found
```

**Solution:**
Install live-build:
```bash
sudo apt-get update
sudo apt-get install -y live-build debootstrap squashfs-tools xorriso
```

### Issue: Docker build fails

**Error Message:**
```
Cannot connect to Docker daemon
```

**Solution:**
- Ensure Docker is running: `sudo systemctl start docker`
- Add user to docker group: `sudo usermod -aG docker $USER`
- Log out and back in

## Getting Help

If you encounter issues not covered here:

1. Check the build logs for specific error messages
2. Verify all prerequisites are installed
3. Review the [Build Instructions](build-instructions.md)
4. Check GitHub Issues for similar problems
5. Create a new issue with:
   - Error message
   - Build environment (OS, version)
   - Full build log

