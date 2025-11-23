#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="${1:-release/apt-repo}"
CODENAME="${CODENAME:-croclinux}"
SUITE="${SUITE:-stable}"
COMPONENTS="${COMPONENTS:-main contrib}"
ARCHES="${ARCHES:-amd64}"
SIGN_KEY="${SIGN_KEY:-}" # Optional GPG key ID for signing

mkdir -p "$REPO_ROOT/conf"

cat <<CONF > "$REPO_ROOT/conf/distributions"
Codename: $CODENAME
Suite: $SUITE
Components: $COMPONENTS
Architectures: $ARCHES
Description: CrocLinux APT Repository
${SIGN_KEY:+SignWith: $SIGN_KEY}
CONF

cat <<CONF > "$REPO_ROOT/conf/options"
verbose
basedir $REPO_ROOT
CONF

echo "[+] Repository configuration written to $REPO_ROOT/conf"

echo "Usage: $0 [repo_root] <deb-files>"

echo "[+] Importing packages..."
shift 1 || true
for deb in "$@"; do
  if [[ -f "$deb" ]]; then
    reprepro -b "$REPO_ROOT" includedeb "$CODENAME" "$deb"
  else
    echo "[!] Skipping missing package: $deb" >&2
  fi
done

echo "[+] Repository metadata created at $REPO_ROOT"

echo "[+] To publish via nginx or S3, sync $REPO_ROOT" 
