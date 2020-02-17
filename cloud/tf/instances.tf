resource "aws_key_pair" "cka_user_key" {
  key_name   = "${var.owner}_cka_key"
  public_key = var.ssh_key
}

resource "aws_instance" "masters" {

  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.cka_user_key.key_name

  vpc_security_group_ids = [
    aws_security_group.ssh_access.id,
    aws_security_group.masters.id,
    aws_security_group.internal.id
  ]
  subnet_id = aws_subnet.control_plane.id

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
  instance_type = "t2.micro"
  key_name      = aws_key_pair.cka_user_key.key_name

  vpc_security_group_ids = [
    aws_security_group.ssh_access.id,
    aws_security_group.internal.id
  ]
  subnet_id = aws_subnet.control_plane.id

  tags = merge(
    local.common_tags,
    { Name = "${local.prefix}_workers_${count.index}" }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}
