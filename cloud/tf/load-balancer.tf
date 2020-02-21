resource "aws_eip" "apiserver_ip" {
  vpc = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}_apiserver_ip"
    }
  )

  lifecycle {
    ignore_changes = [tags["AutoTag_Creator"]]
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.masters[0].id
  allocation_id = aws_eip.apiserver_ip.id
}
