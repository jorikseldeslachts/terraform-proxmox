# tf-proxmox


## About
This project can be used to automate the creation of virtual machines on Proxmox.


## Docs
- [vectops.com](https://vectops.com/2020/05/provision-proxmox-vms-with-terraform-quick-and-easy/)
- [Telmate/Proxmox](https://github.com/Telmate/terraform-provider-proxmox)
- [Proxmox docs](https://pve.proxmox.com/pve-docs/qm.1.html)
- [norocketscience.at](https://norocketscience.at/provision-proxmox-virtual-machines-with-terraform/)
- [cloud-init image Proxmox docs](https://pve.proxmox.com/wiki/Cloud-Init_Support)
- [fix for cloud-init can not parse issue](https://forum.proxmox.com/threads/errors-following-doc-preparing-cloud-init-templates.45640/)
- [yetiops.net](https://yetiops.net/posts/proxmox-terraform-cloudinit-saltstack-prometheus/)
- [Cloud-Init Proxmox video](https://www.youtube.com/watch?v=Ygk7oq--mak&ab_channel=GatewayITTutorials)


## Proxmox VM Templates
Before Terraform can create virtual machines, we need to prepare templates that Terraform can then clone.

Example: Ubuntu 20.04 Template
```sh
# SSH into the PVE host

# download the cloud-init iso (Openstack ready cloud-init images)
$ cd /var/lib/vz/template/iso/
$ wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img

# Set vmid to use
$ export VM_ID="1002"

# create vm and import the iso image (cqow2 format)
$ qm create $VM_ID \
    --name template-ubuntu-2004-focal-fossa \
    --ostype l26 \
    --memory 1024 \
    --sockets 1 \
    --cores 1 \
    --vcpu 1  \
    --numa 1 \
    --net0 virtio,bridge=vmbr42 \
    --agent 1

$ qm importdisk $VM_ID focal-server-cloudimg-amd64.img local --format qcow2

# set some options
$ qm set $VM_ID --scsihw virtio-scsi-pci
$ qm set $VM_ID --virtio0 local:$VM_ID/vm-$VM_ID-disk-0.qcow2
$ qm set $VM_ID --ide2 local:cloudinit
$ qm set $VM_ID --boot c --bootdisk virtio0
$ qm set $VM_ID --serial0 socket
$ qm set $VM_ID --hotplug network,disk,cpu,memory,usb

# convert the VM to the template
$ qm template $VM_ID
```


## Terraform

### Prepare Terraform

Run this on the Proxmox host:
- Create a Proxmox user for Terraform (commands on Proxmox host cli):
  ```sh
  $ pveum user add terraform@pve --password "some-secure-password"
  $ pveum aclmod / -user terraform@pve -role Administrator
  ```

Run this on the machine running Terraform:
- Prepare ssh keypair for the new VM:
  ```sh
  $ ssh-keygen -t rsa -b 4096 -N "" -q -C "terraform-vm" -f ~/.ssh/tf-vm
  ```
- Activate logging if you prefer it:
  ```sh
  $ export TF_LOG=1
  ```
- Export the terraform user password as environment variable:
  ```sh
  $ export PM_PASS="some-secure-password"
  ```
- Run Terraform:
  ```sh
  # Install all providers
  $ terraform init

  # Validate files
  $ terraform validate

  # Plan / Apply specific OS version
  # terraform apply --var-file=$(pwd)/templates/<OS Template>/vars.tf
  $ terraform apply --var-file=$(pwd)/templates/ubuntu_20.04_focal-fossa/vars.tf
  ```
