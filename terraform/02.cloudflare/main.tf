terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.15.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token

}

resource "cloudflare_dns_record" "minecraft_dns_srv_record" {
  zone_id = var.zone_id
  name    = var.mc_srv_name
  ttl     = 1
  type    = "SRV"
  proxied = false
  comment = "SRV Record for minecraft"
  data = {
    priority = 0
    weight   = 0
    port     = 25565
    target   = var.mc_target
  }
}
