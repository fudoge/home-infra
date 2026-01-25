output "frr_ip" {
  value = module.frrouter.ips
}
output "gateway_ip" {
  value = var.frr_ip
}
