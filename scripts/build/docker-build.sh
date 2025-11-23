#!/usr/bin/env bash
# Build CrocLinux ISO using Docker (works on macOS/Windows/Linux)

set -euo pipefail

VARIANT="${1:-full}"

# Build Docker image with live-build tools
docker build -t croclinux-builder -f scripts/build/Dockerfile.build .

# Run build inside container
docker run --rm -it \
  -v "$(pwd):/workspace" \
  -w /workspace \
  croclinux-builder \
  ./scripts/build/build_iso_variant.sh "$VARIANT"

echo "[+] ISO build complete. Check release/ directory."

