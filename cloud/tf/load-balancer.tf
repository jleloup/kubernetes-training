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
