terraform {
  required_version = "~> 1.5.0"

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
  regions = [
    # "nyc1", # New York 1
    # "nyc3", # New York 3
    # "ams3", # Amsterdam
    # "sfo2", # San Francisco 2
    # "sfo3", # San Francisco 3
    # "sgp1", # Singapore
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
  # this costs about $6/month, but you can run a bigger one if you want
  size      = "s-1vcpu-1gb"
  user_data = file("./setup-veilid.yaml")
}
