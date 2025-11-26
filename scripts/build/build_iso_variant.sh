#!/usr/bin/env bash
# Build CrocLinux ISO variant (full or mini)

set -euo pipefail

VARIANT="${1:-full}"
CONFIG_DIR="build/iso/config/package-lists"
PACKAGE_LIST="${CONFIG_DIR}/croc.list.chroot"

case "$VARIANT" in
  full)
    SOURCE_LIST="${CONFIG_DIR}/croclinux-full.list.chroot"
    ;;
  mini)
    SOURCE_LIST="${CONFIG_DIR}/croclinux-mini.list.chroot"
    ;;
  *)
    echo "Usage: $0 [full|mini]" >&2
    exit 1
    ;;
esac

if [[ ! -f "$SOURCE_LIST" ]]; then
  echo "[!] Package list $SOURCE_LIST not found" >&2
  exit 1
fi

# Copy selected package list
cp "$SOURCE_LIST" "$PACKAGE_LIST"
echo "[+] Using package list $SOURCE_LIST"

# Get absolute path to project root
PROJECT_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$PROJECT_ROOT"

# Create a completely separate build directory outside source tree
BUILD_ROOT="/tmp/croclinux-build-$$"
# Remove directory if it exists and create fresh
sudo rm -rf "$BUILD_ROOT" 2>/dev/null || true
mkdir -p "$BUILD_ROOT"
cd "$BUILD_ROOT"

echo "[+] Working in clean build directory: $BUILD_ROOT"

# Ensure directory is completely empty
sudo rm -rf .* * 2>/dev/null || true

# COMPLETELY SKIP lb config - manually create everything live-build needs
echo "[+] Manually creating complete live-build config structure (skipping lb config)"

# Create all required directories
mkdir -p config/package-lists
mkdir -p config/includes.chroot
mkdir -p config/includes.binary
mkdir -p config/preseed
mkdir -p config/archives
mkdir -p config/source
mkdir -p config/hooks

# Create the auto/config script - this is what lb config normally creates
mkdir -p config/auto
cat > config/auto/config <<'EOF'
#!/bin/sh
# Auto-generated config script for CrocLinux
# This replaces what lb config would normally create

LB_DISTRIBUTION="bookworm"
LB_ARCHITECTURES="amd64"
LB_LINUX_FLAVOURS="amd64"
LB_DEBIAN_MIRROR="http://deb.debian.org/debian/"
LB_SECURITY_MIRROR="http://security.debian.org/"
LB_BOOTAPPEND_LIVE="boot=live components hostname=croc username=analyst locales=en_US.UTF-8"
LB_DESKTOP="xfce"
LB_ISO_APPLICATION="CrocLinux"
LB_ISO_VOLUME="CROC_LINUX_GUARDIAN"
LB_IMAGE_NAME="croc-linux"
EOF

chmod +x config/auto/config

# Copy our custom configuration files from source
echo "[+] Copying custom configuration files from source"

SOURCE_CONFIG="$PROJECT_ROOT/build/iso/config"
SOURCE_PRESEED="$PROJECT_ROOT/build/iso/preseed"
SOURCE_SCRIPTS="$PROJECT_ROOT/build/iso/scripts"

# Copy package lists
if [[ -d "$SOURCE_CONFIG/package-lists" ]]; then
  sudo mkdir -p config/package-lists
  sudo cp "$SOURCE_CONFIG/package-lists"/*.chroot config/package-lists/ 2>/dev/null || true
fi

# Ensure the selected package list is in place
if [[ -f "$SOURCE_CONFIG/package-lists/croc.list.chroot" ]]; then
  sudo cp "$SOURCE_CONFIG/package-lists/croc.list.chroot" config/package-lists/
fi

# Copy includes.chroot (files to include in the system)
if [[ -d "$SOURCE_CONFIG/includes.chroot" ]]; then
  sudo cp -r "$SOURCE_CONFIG/includes.chroot"/* config/includes.chroot/ 2>/dev/null || true
fi

# Copy includes.binary (files for the ISO)
if [[ -d "$SOURCE_CONFIG/includes.binary" ]]; then
  sudo cp -r "$SOURCE_CONFIG/includes.binary"/* config/includes.binary/ 2>/dev/null || true
fi

# Copy preseed files
if [[ -d "$SOURCE_PRESEED" ]]; then
  sudo mkdir -p config/preseed
  sudo cp "$SOURCE_PRESEED"/* config/preseed/ 2>/dev/null || true
fi

# Copy scripts to chroot
if [[ -d "$SOURCE_SCRIPTS" ]]; then
  sudo mkdir -p config/includes.chroot/opt/croc/scripts
  sudo cp -r "$SOURCE_SCRIPTS"/* config/includes.chroot/opt/croc/scripts/ 2>/dev/null || true
  # Make scripts executable
  sudo find config/includes.chroot/opt/croc/scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
fi

# Verify config structure
if [[ ! -d config ]] || [[ ! -f config/auto/config ]]; then
  echo "[!] Error: Config structure not properly created" >&2
  exit 1
fi

echo "[+] Config directory structure ready (lb config skipped to avoid git clone issue)"

# Build ISO directly - lb build should work with manually created config
echo "[+] Starting ISO build (this will take 30-60 minutes)..."
echo "[+] This is a long process - please be patient"
echo "[+] Note: Using manually created config (lb config was skipped)"

# Run lb build - it should use our manually created config
sudo lb build

# Check for output ISO
ISO_SRC="binary/live-image-amd64.hybrid.iso"
if [[ ! -f "$ISO_SRC" ]]; then
  # Try alternative location
  ISO_SRC="live-image-amd64.hybrid.iso"
  if [[ ! -f "$ISO_SRC" ]]; then
    echo "[!] Expected ISO not found. Checking for any ISO files..."
    find . -name "*.iso" -type f || true
    exit 1
  fi
fi

# Move ISO to release directory
DATE_TAG=$(date +%Y%m%d)
ISO_DEST="$PROJECT_ROOT/release/CrocLinux-${VARIANT}-${DATE_TAG}.iso"

mkdir -p "$PROJECT_ROOT/release"
mv "$ISO_SRC" "$ISO_DEST"

echo "[+] ISO written to $ISO_DEST"

# Generate checksums
cd "$PROJECT_ROOT/release"
if command -v sha256sum >/dev/null; then
  sha256sum "CrocLinux-${VARIANT}-${DATE_TAG}.iso" >> sha256sums.txt
  echo "[+] SHA-256 checksum appended to release/sha256sums.txt"
fi
if command -v sha512sum >/dev/null; then
  sha512sum "CrocLinux-${VARIANT}-${DATE_TAG}.iso" >> sha512sums.txt
  echo "[+] SHA-512 checksum appended to release/sha512sums.txt"
fi

# Cleanup build directory
echo "[+] Cleaning up temporary build directory"
cd "$PROJECT_ROOT"
sudo rm -rf "$BUILD_ROOT" 2>/dev/null || true

echo "[+] Build complete! ISO: $ISO_DEST"
