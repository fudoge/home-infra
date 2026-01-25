output "k8s_node_ips" {
  value = {
    for k, ip in module.k8s-node :
    k => ip.ips
  }
}
