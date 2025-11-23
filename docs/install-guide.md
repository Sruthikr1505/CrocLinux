# CrocLinux Installation Guide (VirtualBox Edition)

## 1. Prepare the Environment
- Download the latest `croc-linux.iso` generated from the `build/iso` pipeline.
- Install Oracle VirtualBox 7.x or later on the host workstation.
- Allocate at least:
  - 4 vCPUs (enable PAE/NX and nested virtualization if supported)
  - 16 GB RAM (increase to 24–32 GB for intensive elasticity tests)
  - 160 GB dynamically allocated VDI disk

## 2. Create the Virtual Machine
1. Open VirtualBox and click **New**.
2. Set **Name** to `CrocLinux-SOC`, **Type** to `Linux`, **Version** to `Debian (64-bit)`.
3. Assign memory and CPU resources per the requirements above.
4. Choose **Create a virtual hard disk now** → **VDI** → **Dynamically allocated** → 160 GB.
5. After VM creation, open **Settings → System → Processor**:
   - Enable **Extended Features → PAE/NX**.
   - Set **Processor(s)** to at least 4.
6. Attach ISO:
   - **Settings → Storage** → select Empty optical drive → choose the `croc-linux.iso`.
   - Enable **Live CD/DVD** option for the first boot.
7. Enable networking:
   - Adapter 1: **Bridged Adapter** (or NAT as fallback).
   - Adapter 2 (optional): **Host-Only Adapter** for isolated sensor mirroring.

## 3. Boot and Launch Installer
1. Start the VM and select **Install CrocLinux** from the boot menu.
2. Follow the guided Debian installer prompts:
   - **Language:** English
   - **Locale:** `en_US.UTF-8`
   - **Keyboard:** `US`
   - **Hostname:** `croc-soc`
   - **Domain Name:** optional (e.g., `lab.local`)
   - **User Full Name:** `SOC Analyst`
   - **Username:** `analyst`
   - **Password:** `Croc!2025`
3. Network configuration uses DHCP by default; configure static IP if required for SOC operations.

## 4. Disk Partitioning
- Choose **Guided - use entire disk and set up LVM**.
- Accept default partition layout (one volume group with root + swap).
- Confirm write actions to disk when prompted.

## 5. Package Selection
- The CrocLinux live-build includes all required packages automatically.
- When prompted for additional packages, leave defaults (SSH server & standard system utilities).

## 6. GRUB Installation
- Install GRUB to the primary disk (e.g., `/dev/sda`).
- Allow the installer to finish copying files and configuring services.

## 7. First Reboot
1. When prompted, remove the ISO (VirtualBox → Devices → Optical Drives → Remove disk).
2. Reboot the VM to boot from the installed system.
3. Log in as `analyst / Croc!2025`.

## 8. Post-Install Checklist
- Update secrets: run `sudo crocsec update_rules` and change all `CHANGE_ME` placeholders.
- Configure TLS certificates for Kibana, Wazuh, and MISP if exposing externally.
- (Optional) Add additional NICs for SPAN/mirroring traffic to Suricata.

## Troubleshooting
- If Elastic services fail: verify VM has at least 12 GB RAM free (`htop`).
- For headless deployments, CrocLinux can be installed via the same ISO using preseed automation.
- Logs for installer actions reside in `/var/log/croc-linux-prepare.log` and related files.

> For physical installations, follow the same steps using `dd` or `Rufus` to create a bootable USB.
