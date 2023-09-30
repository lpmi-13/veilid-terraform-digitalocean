output "public_ip" {
  value = [
    for node in digitalocean_droplet.veilid-node : node.ipv4_address
  ]
}
