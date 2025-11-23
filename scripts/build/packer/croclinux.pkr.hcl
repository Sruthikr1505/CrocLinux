# CrocLinux Packer configuration for automated VM image creation
# Similar to Kali Linux VM image generation

variable "iso_file" {
  type    = string
  default = ""
}

variable "variant" {
  type    = string
  default = "full"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  image_name = "CrocLinux-${var.variant}-${local.timestamp}"
}

source "virtualbox-iso" "croclinux" {
  iso_url      = var.iso_file
  iso_checksum = "none"
  
  guest_os_type = "Ubuntu_64"
  vm_name       = local.image_name
  
  disk_size    = 80000
  memory       = 4096
  cpus         = 2
  
  ssh_username = "analyst"
  ssh_password = "Croc!2025"
  ssh_timeout  = "20m"
  
  boot_wait = "10s"
  
  boot_command = [
    "<esc><wait>",
    "install<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    "<enter><wait>"
  ]
  
  http_directory = "http"
  
  shutdown_command = "echo 'Croc!2025' | sudo -S shutdown -P now"
  shutdown_timeout = "5m"
  
  format         = "ova"
  output_filename = "../../../release/vm-build/${local.image_name}.ova"
}

source "vmware-iso" "croclinux" {
  iso_url      = var.iso_file
  iso_checksum = "none"
  
  guest_os_type = "ubuntu-64"
  vm_name       = local.image_name
  
  disk_size    = 80000
  memory       = 4096
  cpus         = 2
  
  ssh_username = "analyst"
  ssh_password = "Croc!2025"
  ssh_timeout  = "20m"
  
  boot_wait = "10s"
  
  boot_command = [
    "<esc><wait>",
    "install<wait>",
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg<wait>",
    "<enter><wait>"
  ]
  
  http_directory = "http"
  
  shutdown_command = "echo 'Croc!2025' | sudo -S shutdown -P now"
  shutdown_timeout = "5m"
  
  disk_type_id = "0"
  format        = "ova"
  output_filename = "../../../release/vm-build/${local.image_name}-vmware.ova"
}

build {
  sources = ["source.virtualbox-iso.croclinux", "source.vmware-iso.croclinux"]
  
  provisioner "shell" {
    inline = [
      "echo '[+] Post-install configuration'",
      "sudo /opt/croc/scripts/base/prepare_system.sh || true",
      "sudo /opt/croc/scripts/base/hardening.sh || true",
      "sudo /opt/croc/scripts/services/install_blue_team_stack.sh || true",
      "sudo /opt/croc/scripts/automation/setup_integrations.sh || true",
      "echo '[+] VM image preparation complete'"
    ]
  }
  
  post-processor "shell-local" {
    inline = [
      "echo '[+] VM image created: ${local.image_name}.ova'"
    ]
  }
}

