#!/usr/bin/env bash
# Build CrocLinux VM images (OVA, VMDK) from ISO - Similar to Kali Linux

set -euo pipefail

VARIANT="${1:-full}"
ISO_FILE=""
DATE_TAG=$(date +%Y%m%d)

# Find the most recent ISO
ISO_FILE=$(ls -t release/CrocLinux-${VARIANT}-*.iso 2>/dev/null | head -n1)

if [[ ! -f "$ISO_FILE" ]]; then
  echo "[!] ISO file not found. Build ISO first: ./scripts/build/build_iso_variant.sh $VARIANT" >&2
  exit 1
fi

echo "[+] Found ISO: $ISO_FILE"
echo "[+] Building VM images for variant: $VARIANT"

# Create VM build directory
mkdir -p release/vm-build

# Install required tools for VM creation
if ! command -v qemu-img >/dev/null 2>&1; then
  echo "[+] Installing QEMU tools for VM image creation"
  sudo apt-get update
  sudo apt-get install -y qemu-utils ovftool || echo "[!] Some tools may not be available"
fi

# Build using Packer (if available)
if command -v packer >/dev/null 2>&1; then
  echo "[+] Using Packer to build VM images"
  cd scripts/build/packer
  packer init .
  packer build -var "iso_file=../../$ISO_FILE" -var "variant=$VARIANT" croclinux.pkr.hcl
  cd - >/dev/null
else
  echo "[!] Packer not found. Install Packer for automated VM image creation."
  echo "[!] Manual VM creation:"
  echo "    1. Create VM in VirtualBox/VMware"
  echo "    2. Attach ISO: $ISO_FILE"
  echo "    3. Install CrocLinux"
  echo "    4. Export as OVA/VMDK"
  echo "[+] See docs/vm-image-creation.md for detailed instructions"
fi

echo "[+] VM image build process complete"
echo "[+] Check release/vm-build/ for OVA and VMDK files"

