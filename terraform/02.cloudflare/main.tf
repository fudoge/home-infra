terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.19.0"
    }
  }
}

provider "cloudflare" {
  alias     = "core"
  api_token = var.cloudflare_api_token
}

provider "cloudflare" {
  alias     = "r2"
  api_token = var.cloudflare_r2_api_token
}

resource "cloudflare_dns_record" "minecraft_dns_srv_record" {
  provider = cloudflare.core
  zone_id  = var.zone_id
  name     = var.mc_srv_name
  ttl      = 1
  type     = "SRV"
  proxied  = false
  comment  = "SRV Record for minecraft"
  data = {
    priority = 0
    weight   = 0
    port     = 25565
    target   = var.mc_target
  }
}

resource "cloudflare_dns_record" "blog" {
  provider = cloudflare.core
  zone_id  = var.zone_id
  name     = "blog"
  content  = "${var.gh_username}.github.io"
  ttl      = 1
  type     = "CNAME"
  proxied  = false
  comment  = "Hugo blog Custom Domain"
}

resource "cloudflare_r2_bucket" "public_bucket" {
  provider      = cloudflare.r2
  name          = "public-deploy"
  account_id    = var.account_id
  storage_class = "Standard"
}

resource "cloudflare_r2_custom_domain" "public_bucket_custom_domain" {
  provider    = cloudflare.r2
  account_id  = var.account_id
  bucket_name = cloudflare_r2_bucket.public_bucket.name
  domain      = "assets.chaewoon.work"
  enabled     = true
  zone_id     = var.zone_id
  min_tls     = "1.3"
}
