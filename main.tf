terraform {
  required_version = ">= 1.5.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# instead of putting your auth credentials here, it's better to set your auth credentials in the cli via
# export DIGITALOCEAN_ACCESS_TOKEN
# get a token at https://cloud.digitalocean.com/account/api/tokens
provider "digitalocean" {}

locals {
  # uncomment the region(s) where you want to start up a veilid node
  # NOTE: the current selected size (ie, s-1vcpu-512mb-10gb) isn't available in all regions
  regions = [
    # "nyc1", # New York 1
    # "nyc3", # New York 3
    # "ams3", # Amsterdam
    # "sfo2", # San Francisco 2
    # "sfo3", # San Francisco 3
    "sgp1", # Singapore
    # "lon1", # London
    # "fra1", # Frankfurt
    # "tor1", # Toronto
    # "blr1", # Bangalore
    # "syd1", # Sydney
  ]
}

resource "digitalocean_droplet" "veilid-node" {
  for_each = toset(local.regions)
  image    = "ubuntu-22-04-x64"
  name     = "veilid-node-${each.value}"
  region   = each.value
  ipv6     = true
  # this costs about $4/month, but you can run a bigger one if you want
  size      = "s-1vcpu-512mb-10gb"
  user_data = file("./setup-veilid.yaml")
}

resource "digitalocean_firewall" "veilid" {
  name = "veilid-access"

  droplet_ids = [for node in digitalocean_droplet.veilid-node : node.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "5150"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "5150"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
    port_range            = "all"
  }

  outbound_rule {
    protocol              = "udp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
    port_range            = "all"
  }
}
