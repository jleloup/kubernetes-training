resource "aws_vpc" "vpc_kube" {
  cidr_block           = "10.240.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_vpc" }
  )
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = aws_vpc.vpc_kube.id
  cidr_block = "10.200.0.0/16"
}

resource "aws_subnet" "control_plane" {
  vpc_id     = aws_vpc.vpc_kube.id
  cidr_block = "10.240.0.0/16"

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_control_plane" }
  )
}

resource "aws_subnet" "data_plane" {
  vpc_id     = aws_vpc.vpc_kube.id
  cidr_block = "10.200.0.0/16"

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_data_plane" }
  )
}

resource "aws_security_group" "ssh_access" {
  description = "SSH access on Kubernetes training instances"
  name        = "${local.prefix}_ssh_sg"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }
}

resource "aws_security_group" "masters" {
  description = "Access for Kubernetes training master instances"
  name        = "${local.prefix}_master_sg"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }
}

resource "aws_security_group" "internal" {
  description = "Internal communications for Kubernetes training instances"
  name        = "${local.prefix}_internal_sg"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
}
