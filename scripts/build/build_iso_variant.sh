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

# Navigate to build directory
cd build/iso

# Work in a clean subdirectory to avoid conflicts with source config/
WORK_DIR="work"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Clean previous builds
echo "[+] Cleaning previous builds"
sudo lb clean --purge || true

# Ensure we're starting completely fresh
sudo rm -rf config .build binary cache auto 2>/dev/null || true

# Initialize live-build configuration
echo "[+] Initializing live-build configuration"
sudo lb config \
  --distribution bookworm \
  --architectures amd64 \
  --linux-flavours amd64 \
  --debian-mirror http://deb.debian.org/debian/ \
  --security-mirror http://security.debian.org/ \
  --bootappend-live "boot=live components hostname=croc username=analyst locales=en_US.UTF-8" \
  --desktop xfce \
  --iso-application "CrocLinux" \
  --iso-volume "CROC_LINUX_GUARDIAN" \
  --image-name "croc-linux"

# Copy our custom configuration files into the generated config directory
echo "[+] Copying custom configuration files from source"

# Copy package lists
if [[ -d ../../config/package-lists ]]; then
  sudo mkdir -p config/package-lists
  sudo cp ../../config/package-lists/*.chroot config/package-lists/ 2>/dev/null || true
fi

# Copy includes.chroot (files to include in the system)
if [[ -d ../../config/includes.chroot ]]; then
  sudo cp -r ../../config/includes.chroot/* config/includes.chroot/ 2>/dev/null || true
fi

# Copy includes.binary (files for the ISO)
if [[ -d ../../config/includes.binary ]]; then
  sudo cp -r ../../config/includes.binary/* config/includes.binary/ 2>/dev/null || true
fi

# Copy preseed files
if [[ -d ../../preseed ]]; then
  sudo mkdir -p config/preseed
  sudo cp ../../preseed/* config/preseed/ 2>/dev/null || true
fi

# Copy scripts to chroot
if [[ -d ../../scripts ]]; then
  sudo mkdir -p config/includes.chroot/opt/croc/scripts
  sudo cp -r ../../scripts/* config/includes.chroot/opt/croc/scripts/ 2>/dev/null || true
  # Make scripts executable
  sudo find config/includes.chroot/opt/croc/scripts -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
fi

# Ensure package list is in place
sudo mkdir -p config/package-lists
if [[ -f ../../config/package-lists/croc.list.chroot ]]; then
  sudo cp ../../config/package-lists/croc.list.chroot config/package-lists/
fi

# Build ISO
echo "[+] Starting ISO build (this will take 30-60 minutes)..."
echo "[+] This is a long process - please be patient"
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
ISO_DEST="../../../release/CrocLinux-${VARIANT}-${DATE_TAG}.iso"

mkdir -p ../../../release
mv "$ISO_SRC" "$ISO_DEST"

cd ../../..

echo "[+] ISO written to $ISO_DEST"

# Generate checksums
if command -v sha256sum >/dev/null; then
  (cd release && sha256sum "CrocLinux-${VARIANT}-${DATE_TAG}.iso" >> sha256sums.txt)
  echo "[+] SHA-256 checksum appended to release/sha256sums.txt"
fi
if command -v sha512sum >/dev/null; then
  (cd release && sha512sum "CrocLinux-${VARIANT}-${DATE_TAG}.iso" >> sha512sums.txt)
  echo "[+] SHA-512 checksum appended to release/sha512sums.txt"
fi

echo "[+] Build complete! ISO: $ISO_DEST"
