resource "proxmox_virtual_environment_network_linux_bridge" "vmbr1" {
  node_name = "pve-01"
  name      = "vmbr1"

  address = "192.168.10.1/24"
  comment = "In-proxmox network"
}

module "ubuntu_template" {
  source        = "./modules/template"
  template_name = "ubuntu-template"
  ve_node_name  = "pve-01"
  datastore_id  = "local"
}
