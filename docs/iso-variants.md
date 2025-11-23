# CrocLinux ISO Variants

CrocLinux offers two ISO flavors generated from the same live-build pipeline.

## Variant Overview

| Variant | Package List File                                   | Description                                     |
|---------|------------------------------------------------------|-------------------------------------------------|
| full    | `build/iso/config/package-lists/croclinux-full.list.chroot` | Complete SOC/DFIR toolkit (default experience) |
| mini    | `build/iso/config/package-lists/croclinux-mini.list.chroot` | Lightweight SIEM/IDS core for lab sensors      |

The active package list is copied to `croc.list.chroot` prior to each build.

## Building an ISO
```bash
./scripts/build/build_iso_variant.sh full   # full experience
./scripts/build/build_iso_variant.sh mini   # mini footprint
```

The script will:
1. Copy the chosen package list to `croc.list.chroot`.
2. Run `lb clean`, `lb config`, and `lb build`.
3. Move the resulting ISO to `release/CrocLinux-<variant>-YYYYMMDD.iso`.
4. Append SHA-256 / SHA-512 sums to `release/sha256sums.txt` and `release/sha512sums.txt`.

## Customizing Additional Variants
- Duplicate one of the package list files with a new name, add/remove packages.
- Invoke the script with the new filename via environment variable:
  ```bash
  PACKAGE_FILE=build/iso/config/package-lists/custom.list.chroot \
    VARIANT_NAME=custom ./scripts/build/build_iso_variant.sh
  ```
  (Update the script if you need additional variants frequently.)

## Artifact Publishing
After each ISO build:
- Update `release/links.txt` with final download URLs / magnet links.
- Regenerate torrent files using `mktorrent` or similar tool.
- Sign ISOs with GPG and upload `.iso`, `.iso.asc`, and checksum files to the release distribution point.
