resource "aws_instance" "instance" {

  count         = 3
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  vpc_security_group_ids =
  subnet_id = data.

  tags = merge(
    var.common_tags,
    { Name = "${var.instance_name}-${count.index}" }
  )
}
