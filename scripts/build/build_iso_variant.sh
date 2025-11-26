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
echo "[+] Current directory: $(pwd)"

# Ensure directory is completely empty
sudo rm -rf .* * 2>/dev/null || true

# Unset ALL environment variables that might interfere
unset LB_CONFIG
unset LB_CONFIG_DIRECTORY
unset GIT_DIR
unset GIT_WORK_TREE
unset GIT_INDEX_FILE
unset GIT_CEILING_DIRECTORIES

# Initialize live-build configuration
# Run lb config with explicit parameters - it should create config/ from scratch
echo "[+] Initializing live-build configuration"
echo "[+] Running: lb config (this will create config/ directory)"

# Use a clean environment and run lb config
# The key is to NOT have any config/ directory when we start
LOG_FILE="/tmp/lb_config_$$.log"

# Run lb config in a completely clean environment
sudo env -i \
  HOME="$HOME" \
  PATH="$PATH" \
  USER="$USER" \
  lb config \
  --distribution bookworm \
  --architectures amd64 \
  --linux-flavours amd64 \
  --debian-mirror http://deb.debian.org/debian/ \
  --security-mirror http://security.debian.org/ \
  --bootappend-live "boot=live components hostname=croc username=analyst locales=en_US.UTF-8" \
  --desktop xfce \
  --iso-application "CrocLinux" \
  --iso-volume "CROC_LINUX_GUARDIAN" \
  --image-name "croc-linux" > "$LOG_FILE" 2>&1 || {
  echo "[!] Error: lb config failed" >&2
  echo "[!] Full output:" >&2
  cat "$LOG_FILE" >&2 || true
  echo "[!] Current directory: $(pwd)" >&2
  echo "[!] Directory contents:" >&2
  ls -la >&2 || true
  exit 1
}

# Check if config was created
if [[ ! -d config ]]; then
  echo "[!] Error: lb config did not create config/ directory" >&2
  echo "[!] Current directory contents:" >&2
  ls -la >&2 || true
  exit 1
fi

echo "[+] Config directory created successfully"

# Copy our custom configuration files into the generated config directory
echo "[+] Copying custom configuration files from source"

SOURCE_CONFIG="$PROJECT_ROOT/build/iso/config"
SOURCE_PRESEED="$PROJECT_ROOT/build/iso/preseed"
SOURCE_SCRIPTS="$PROJECT_ROOT/build/iso/scripts"

# Copy package lists
if [[ -d "$SOURCE_CONFIG/package-lists" ]]; then
  sudo mkdir -p config/package-lists
  sudo cp "$SOURCE_CONFIG/package-lists"/*.chroot config/package-lists/ 2>/dev/null || true
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

# Ensure package list is in place
sudo mkdir -p config/package-lists
if [[ -f "$SOURCE_CONFIG/package-lists/croc.list.chroot" ]]; then
  sudo cp "$SOURCE_CONFIG/package-lists/croc.list.chroot" config/package-lists/
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
