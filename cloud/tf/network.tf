locals {

  common_tags = {
    region     = var.region
    owner      = var.owner
    repository = var.repository
  }

}

resource "aws_vpc" "vpc-kube" {
  cidr_block           = "10.240.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    { Name = "kubernetes-training" }
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.vpc-kube.id
  cidr_block = "10.200.0.0/16"
}

resource "aws_subnet" "control-plane" {
  vpc_id     = aws_vpc.vpc-kube.id
  cidr_block = "10.240.0.0/16"

  tags = merge(
    local.common_tags,
    { Name = "kubernetes-training-control-plane" }
  )
}

resource "aws_subnet" "data-plane" {
  vpc_id     = aws_vpc.vpc-kube.id
  cidr_block = "10.200.0.0/16"

  tags = merge(
    local.common_tags,
    { Name = "kubernetes-training-data-plane" }
  )
}

