variable "region" {
  type        = string
  description = "AWS region name where the topology lives."
  default     = "us-east-1"
}

variable "owner" {
  type        = string
  description = "Name of the person taking the training"
}

variable "repository" {
  type        = string
  description = "URL of the Git repository for this module."
}

variable "ssh_key" {
  type        = string
  description = "SSH public key to provision on instances."
}

locals {

  prefix = "cka_${var.owner}"

  common_tags = {
    region     = var.region
    owner      = var.owner
    repository = var.repository
    cka        = "true"
  }

  allowed_ips = [
    "62.23.50.122/32"
  ]
}
