variable "name" {
  description = "Name of the cluster"
  type        = string
}

variable "hcloud_ssh_key" {
  description = "SSH key name or ID"
  type        = string
}

variable "master_server_type" {
  description = "Server SKU"
  type        = string
  default     = "cx31"
}

variable "worker_server_type" {
  description = "Server SKU"
  type        = string
  default     = "cx31"
}

variable "hcloud_token" {
  description = "Hetzner token for CCM and storage provisioner"
  type        = string
  sensitive   = true
}

variable "master_count" {
  description = "Hetzner token for CCM and storage provisioner"
  type        = number
  default     = 1
}

variable "control_plane_lb_type" {
  description = "Hetzner token for CCM and storage provisioner"
  type        = string
  default     = ""
}

variable "control_plane_endpoint" {
  description = "Optional DNS name for the control plane endpoint"
  type        = string
  default     = ""
}

variable "service_cidr_ipv6" {
  description = "IPv6 CIDR for Services"
  type        = string
  default     = "fd00::/112"
}

variable "service_cidr_ipv4" {
  description = "IPv4 CIDR for Services"
  type        = string
  default     = "172.16.0.0/16"
}

variable "worker_count" {
  description = "Number of worker nodes"
  type        = number
}

variable "image" {
  description = "Image for the nodes"
  type        = string
  default     = "ubuntu-20.04"
}

variable "location" {
  description = "Server location"
  type        = string
  default     = "hel1"
}

variable "ssh_private_key_path" {
  description = "SSH public key file path"
  type        = string
  default     = "~/.ssh/id_rsa"
}