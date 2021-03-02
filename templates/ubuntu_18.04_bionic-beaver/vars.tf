# template details
os_description = "Ubuntu 18.04 Bionic Beaver"
proxmox_template = "template-ubuntu-1804-bionic-beaver"
provisioning_script_path = "templates/ubuntu_18.04_bionic-beaver/provision.sh.tpl"


# pve connection
pm_api_url = "https://<proxmox-server>:8006/api2/json"
pm_user = "proxmox-user"
target_node = "proxmox-node"

# vm resources
storage_name = "local"
disksize = "5G"
sockets = 1
cores = 1
memory = 1024
balloon = 512

# vm user
user = "tfuser"
password = "Change-me-asap!"
ssh_key_public = "~/.ssh/tf-vm.pub"
ssh_key_private = "~/.ssh/tf-vm"

# vm network settings
gateway = "192.168.0.1"
nameserver = "192.168.0.2"
subnet_short = "24"
searchdomain = "mydomain.test"
bridge = "vmbr0"

# vm provisioning settings
timezone = "Europe/Brussels"

# vm's to be created (All lists must have equal lenghts!)
vmids = [ 10021, 10022 ]
ipv4s = [ "192.168.0.21", "192.168.0.22" ]
hostnames = [ "server-1", "server-2" ]
