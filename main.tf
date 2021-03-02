# Render template for provisioning script
data "template_file" "provisioning_script" {
  template  = file("${path.module}/${var.provisioning_script_path}")
  vars = {
    user = var.user
    timezone = var.timezone
  }
}

# Create the VM
resource "proxmox_vm_qemu" "proxmox-vm" {

  # amount of instances
  count = length(var.hostnames)

  # notes in pve UI
  desc = <<-EOT
    ------------------------------------------------------
    OS Type:     ${var.os_description}
    Created at:  ${formatdate("EEE DD/MM/YYYY hh'h'mm AA (ZZZ)", timestamp())}
    Created by:  Terraform
    ------------------------------------------------------
    EOT

  # vm details
  vmid = var.vmids[count.index]
  name = var.hostnames[count.index]
  target_node = var.target_node

  # template to clone
  clone = var.proxmox_template
  full_clone = true
  os_type = "cloud-init"

  # resources
  memory = var.memory
  balloon = 256
  sockets = var.sockets
  cores = var.cores
  cpu = "kvm64"
  numa = true

  # extra vm settings
  boot =  "c"
  bootdisk = "virtio0"
  scsihw = "virtio-scsi-pci"
  onboot = true
  agent =  1
  hotplug = "network,disk,cpu,memory"

  # network interface
  network {
    model = "virtio"
    bridge = var.bridge
  }

  # storage
  disk {
    type = "virtio"
    storage = var.storage_name
    size = var.disksize
  }

  # cloud init
  # cicustom does not quit work yet, might be usable in next versions
  # cicustom = "user=local:snippets/cloud_init_ubuntu_focal.yml"
  ipconfig0 = "ip=${var.ipv4s[count.index]}/${var.subnet_short},gw=${var.gateway}"
  nameserver = var.nameserver
  searchdomain = var.searchdomain
  ciuser = var.user
  cipassword = var.password
  sshkeys = file(var.ssh_key_public)

  # Check if VM is ready:
  # Terraform will not continue unless the connection is successful
  connection {
    type = "ssh"
    agent = false
    timeout = "3m"
    host = var.ipv4s[count.index]
    user = var.user
    private_key = file(var.ssh_key_private)
  }

  # provision vm with basic config
  provisioner "file" {
    destination = "/tmp/provision.sh"
    content     = data.template_file.provisioning_script.rendered
  }

  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "hostnamectl set-hostname ${var.hostnames[count.index]}",
      "chmod +x /tmp/provision.sh",
      "sudo /tmp/provision.sh"
    ]
  }

  # Ignore network changes since TF generates a new MAC address
  # on every apply causing the vm to upate on every apply.
  lifecycle {
     ignore_changes = [
       network
     ]
  }

}
