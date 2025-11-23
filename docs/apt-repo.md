# CrocLinux APT Repository (reprepro)

## Overview
Use `reprepro` to publish signed `.deb` packages (agents, tooling, updates) so CrocLinux systems can receive upgrades via `apt`.

## Prerequisites
- Debian/Ubuntu build host
- Installed packages: `reprepro`, `gnupg`, `rsync`
- GPG key for signing (optional but recommended)

## Step-by-Step

### 1. Generate / Import GPG Key (optional)
```bash
gpg --full-generate-key
# Note the key ID, e.g., ABC12345
```

### 2. Prepare Packages
Place `.deb` files in `release/debs/`. Example: `crosec-assistant_1.1.0_amd64.deb`.

### 3. Run publishing script
```bash
SIGN_KEY=ABC12345 ./scripts/repo/publish_repo.sh release/apt-repo release/debs/*.deb
```
This will:
- Create `release/apt-repo/conf/` metadata
- Include each `.deb` under codename `croclinux`
- Sign packages using the provided key (if set)

### 4. Serve the Repository
- Rsync `release/apt-repo` to web server root (`https://downloads.croclinux.org/apt/`)
- Or upload to object storage (S3/R2) and expose via CDN.

### 5. Client Configuration
On CrocLinux systems:
```bash
curl -fsSL https://downloads.croclinux.org/apt/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/croclinux-archive.gpg

echo "deb [signed-by=/usr/share/keyrings/croclinux-archive.gpg] https://downloads.croclinux.org/apt croclinux main contrib" | sudo tee /etc/apt/sources.list.d/croclinux.list

sudo apt-get update
```

### 6. Maintenance
- To remove a package: `reprepro -b release/apt-repo remove croclinux <package-name>`
- Re-run publish script after building new `.deb`s
- Keep `conf/distributions` and `options` under version control for reproducibility

### Automation Tips
- Add a GitHub Action to build `.deb` packages, run the script, and push repo to an artifacts bucket.
- Use `aptly` if you need snapshot management or mirrors; `reprepro` suffices for lightweight workflows.
