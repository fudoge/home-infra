variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
}
variable "zone_id" {
  description = "DNS Zone ID"
  type        = string
}
variable "mc_srv_name" {
  description = "Minecraft server srv record name"
  type        = string
}
variable "mc_target" {
  description = "Minecraft server srv target"
  type        = string
}
