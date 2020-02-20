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
    "62.23.50.122/32",
    "50.205.163.56/30",
    "70.165.35.232/29",
    "142.54.226.112/28",
    "149.97.160.218/32",
    "50.239.63.66/32",
    "38.88.149.154/32",
    "194.79.148.236/30",
    "80.65.233.80/29",
    "62.23.50.120/29",
    "84.14.92.154/32",
    "81.255.115.32/29",
    "87.193.254.32/29",
    "87.140.4.212/32",
    "80.155.11.96/29",
    "60.247.114.144/28",
    "101.251.255.208/29",
    "202.134.127.178/32"
  ]
}
