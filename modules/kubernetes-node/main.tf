terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.26.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
}

resource "hcloud_server" "instance" {
  name        = var.name
  ssh_keys    = [var.hcloud_ssh_key]
  image       = var.image
  location    = var.location
  server_type = var.server_type

  firewall_ids = var.firewall_ids
  labels       = var.labels

  connection {
    host        = hcloud_server.instance.ipv4_address
    type        = "ssh"
    timeout     = "5m"
    user        = "root"
    private_key = file(var.ssh_private_key_path)
  }

  provisioner "file" {
    source      = "${path.module}/scripts/prepare-node.sh"
    destination = "/root/prepare-node.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/prepare-node.sh",
      "/root/prepare-node.sh",
    ]
  }

  provisioner "file" {
    source      = "${path.module}/scripts/tailscale.sh"
    destination = "/root/tailscale.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/tailscale.sh",
      "/root/tailscale.sh ${var.tailscale_auth_key}",
    ]
  }
}

module "tailscale_ipv6" {
  source     = "matti/resource/shell"
  depends_on = [hcloud_server.instance]

  trigger = hcloud_server.instance.id

  command = <<EOT
    ssh -i ${var.ssh_private_key_path}  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      root@${hcloud_server.instance.ipv4_address} 'tailscale ip --6'
  EOT
}

module "tailscale_ipv4" {
  source     = "matti/resource/shell"
  depends_on = [hcloud_server.instance]

  trigger = hcloud_server.instance.id

  command = <<EOT
    ssh -i ${var.ssh_private_key_path}  -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
      root@${hcloud_server.instance.ipv4_address} 'tailscale ip --4'
  EOT
}