module "ubuntu_template" {
  source        = "../99.modules/template"
  template_id   = 100
  template_name = "ubuntu-template"
  ve_node_name  = "pve-01"
  datastore_id  = "local"
  image_url     = "https://cloud-images.ubuntu.com/noble/20251113/noble-server-cloudimg-amd64.img"
}

