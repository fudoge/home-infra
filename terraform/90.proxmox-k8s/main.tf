locals {
  ssh_keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDBWhBJ+7YbdJYnNzvHEpkkS4j9bgVHJRFCSWDZXL6adH6Z9XZylsfe3BU2YeieJekst/Vo/WPCYZTGinEN3yvxYhsKK0mvoA0Lwbhp9ExdnkCmaPpIDECC1l1l9AlBdPneE5H5ZwOsoaS8DooG8K22WBLvhJapKkSP05aIxZn9A2JRzfguptfGoQeJsCWZhsoPZCrwcdNqWDDRQlUsz1b2HvirkVbnlmkggLo+NnWcFb6CybmrXwIpgvi0ptPvdzdeA8rF6flVuvD0ALn6ywOR9lKwVCkBEYETo/7bLqS3sfdHwB4pctDP6bdqlm2ZDz/Q0VIZoqE2j1mZnCh8x6oTSxiIurrstJdQRQeASF+LscvuHn0ypqhccESqrdASZmjDKANm/3NZf74HJ20xkQ80e6Gwv9HsQ0DaglPWk3W/lDMxdySE1Hq1dUm7nq8RgHt3k2UISuoTBkMA1WZIc0485ibPFxqM4jBNATfO4Qjp+92awSBkDC5eNXUP744/feSkt0eY6fbpWFiDeajxRd43IePEtjRWiW7FWgW9uXa8Xj6g2vhBsYoljWJ23cHUPYzOBGK+QGZyPiggj8vkPT12sWoznDqAbo8dNBKtaLxkcRAKlhAX566kdrjY+PDOqF5e5pqo9LZpKpLGUzluJG3GZ94PCgbpnQvKQBeYJvJnjQ== kchawoon@naver.com"
  ]

  k8s_nodes = {
    "cp-1" : {
      vm_name     = "cp-1"
      vm_id       = "1010",
      template_id = module.ubuntu_template.id
      cpu_cores   = 4
      memory      = 4096
      networks = [
        { bridge = "vmbr0", ip = "dhcp", gw = "" },
        { bridge = "vmbr1", ip = "192.168.10.10/24", gw = "" }
      ]
    }
    "worker-1" : {
      vm_name     = "worker-1"
      vm_id       = "1100",
      template_id = module.ubuntu_template.id
      cpu_cores   = 4
      memory      = 4096
      networks = [
        { bridge = "vmbr0", ip = "dhcp", gw = "" },
        { bridge = "vmbr1", ip = "192.168.10.100/24", gw = "" }
      ]
    }
    "worker-2" : {
      vm_name     = "worker-2"
      vm_id       = "1101",
      template_id = module.ubuntu_template.id
      cpu_cores   = 4
      memory      = 4096
      networks = [
        { bridge = "vmbr0", ip = "dhcp", gw = "" },
        { bridge = "vmbr1", ip = "192.168.10.101/24", gw = "" }
      ]
    }
  }
}

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

module "frrouter" {
  source       = "./modules/vm"
  node_name    = "pve-01"
  vm_name      = "frr-router"
  vm_id        = 200
  template_id  = module.ubuntu_template.id
  cpu_cores    = 2
  memory       = 2048
  username     = "ubuntu"
  password     = var.password
  datastore_id = "local"
  networks = [
    { bridge = "vmbr0", ip = "dhcp", gw = "" },
    { bridge = "vmbr1", ip = "192.168.10.2/24", gw = "" }
  ]
  ssh_keys = local.ssh_keys
}


module "k8s-node" {
  source       = "./modules/vm"
  node_name    = "pve-01"
  for_each     = local.k8s_nodes
  vm_name      = each.value.vm_name
  vm_id        = each.value.vm_id
  template_id  = module.ubuntu_template.id
  cpu_cores    = each.value.cpu_cores
  memory       = each.value.memory
  username     = "ubuntu"
  password     = var.password
  datastore_id = "local"
  networks     = each.value.networks
  ssh_keys     = local.ssh_keys
}
