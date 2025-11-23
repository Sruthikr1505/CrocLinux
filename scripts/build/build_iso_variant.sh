#!/usr/bin/env bash

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

cp "$SOURCE_LIST" "$PACKAGE_LIST"
echo "[+] Using package list $SOURCE_LIST"

pushd build/iso >/dev/null

sudo lb clean --purge || true
sudo lb config --config ./config
sudo lb build

ISO_SRC="live-image-amd64.hybrid.iso"
if [[ ! -f "$ISO_SRC" ]]; then
  echo "[!] Expected ISO $ISO_SRC not found" >&2
  exit 1
fi

DATE_TAG=$(date +%Y%m%d)
ISO_DEST="../../release/CrocLinux-${VARIANT}-${DATE_TAG}.iso"

mv "$ISO_SRC" "$ISO_DEST"

popd >/dev/null

echo "[+] ISO written to $ISO_DEST"

# Generate checksums
if command -v sha256sum >/dev/null; then
  sha256sum "$ISO_DEST" | tee -a release/sha256sums.txt
fi
if command -v sha512sum >/dev/null; then
  sha512sum "$ISO_DEST" | tee -a release/sha512sums.txt
fi

echo "[+] Checksums appended to release/sha256sums.txt and release/sha512sums.txt"
