resource "aws_key_pair" "cka_user_key" {
  key_name   = "${var.owner}_cka_key"
  public_key = var.ssh_key
}

resource "aws_instance" "masters" {

  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.cka_user_key.key_name

  subnet_id                   = aws_subnet.cka_training.id
  private_ip                  = "10.240.0.${count.index + 11}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.public.id,
    aws_security_group.private.id,
  ]

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_master_${count.index}" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_instance" "workers" {

  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.small"
  key_name      = aws_key_pair.cka_user_key.key_name

  subnet_id                   = aws_subnet.cka_training.id
  private_ip                  = "10.240.0.${count.index + 101}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.public.id,
    aws_security_group.private.id,
  ]

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_workers_${count.index}" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}
