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
  availability_zone = "us-east-1a"
  cidr_block        = "10.240.0.0/16"
  vpc_id            = aws_vpc.vpc_kube.id

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_subnet" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_security_group" "public" {
  description = "Public access for CKA training instances (${var.owner}"
  name        = "${local.prefix}_public"
  vpc_id      = aws_vpc.vpc_kube.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_public" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_security_group_rule" "ssh_rule" {
  type              = "ingress"
  security_group_id = aws_security_group.public.id
  from_port         = 6443
  to_port           = 6443
  protocol          = "tcp"
  cidr_blocks       = local.allowed_ips
}

resource "aws_security_group_rule" "kubernetes_api_rule" {
  type              = "ingress"
  security_group_id = aws_security_group.public.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = local.allowed_ips
}

resource "aws_security_group" "private" {
  description = "Internal communications for CKA instances (${var.owner})"
  name        = "${local.prefix}_private"
  vpc_id      = aws_vpc.vpc_kube.id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_private" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc_kube.id

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_ig" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_kube.id

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_rt" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_route" "route" {
  route_table_id         = aws_route_table.rt_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet" {
  subnet_id      = aws_subnet.cka_training.id
  route_table_id = aws_route_table.rt_public.id
}
