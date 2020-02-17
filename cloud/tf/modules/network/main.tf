locals {
  common_tags = {
    Name  = "kubernetes-training"
    owner = var.owner
  }
}

resource "aws_vpc" "vpc-kube" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.common_tags
}
