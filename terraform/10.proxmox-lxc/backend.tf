terraform {
  backend "s3" {
    bucket       = "riveroverflow-homeserver-backup"
    key          = "proxmox/lxc/terraform.tfstate"
    region       = "ap-northeast-2"
    use_lockfile = true
    encrypt      = true
  }
}
