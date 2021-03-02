terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.6.7"
    }
  }
}

provider "proxmox" {
    pm_api_url      = var.pm_api_url
    pm_user         = var.pm_user
    pm_tls_insecure = "true"
}