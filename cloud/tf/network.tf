resource "aws_vpc" "vpc_kube" {
  cidr_block           = "10.240.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_vpc" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}


resource "aws_subnet" "cka_training" {
  vpc_id     = aws_vpc.vpc_kube.id
  cidr_block = "10.240.0.0/16"

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_subnet" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_security_group" "public_access" {
  description = "Public access for CKA training instances (${var.owner}"
  name        = "${local.prefix}_ssh_sg"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_public" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_security_group" "kubernetes_api" {
  description = "Access for K8S API."
  name        = "${local.prefix}_api"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = local.allowed_ips
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_api" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_security_group" "internal" {
  description = "Internal communications for CKA instances (${var.owner})"
  name        = "${local.prefix}_internal_sg"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_internal" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}
