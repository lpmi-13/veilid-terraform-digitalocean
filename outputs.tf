output "public_ipv4" {
  value = [
    for node in digitalocean_droplet.veilid-node : node.ipv4_address
  ]
}

output "public_ipv6" {
  value = [
    for node in digitalocean_droplet.veilid-node : node.ipv6_address
  ]
}
