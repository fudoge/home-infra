resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id
  clone {
    vm_id = var.template_id
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
  }
  memory {
    dedicated = var.memory
  }

  dynamic "network_device" {
    for_each = var.networks
    content {
      bridge = network_device.value.bridge
    }
  }

  initialization {
    datastore_id      = var.datastore_id
    user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
    user_account {
      username = var.username
      keys     = var.ssh_keys
      password = var.password
    }

    dynamic "ip_config" {
      for_each = var.networks
      content {
        ipv4 {
          address = ip_config.value.ip
          gateway = ip_config.value.gw != "" ? ip_config.value.gw : null
        }
      }
    }
  }
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  node_name    = var.node_name
  datastore_id = var.datastore_id
  content_type = "snippets"

  source_raw {
    data = templatefile("${path.module}/cloud-config.yaml", {
      hostname = var.vm_name
      username = var.username
      ssh_keys = var.ssh_keys
    })
    file_name = "${var.vm_name}.cloud-config.yaml"
  }


}
