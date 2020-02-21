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

resource "aws_lb" "apiserver_lb" {
  name               = "cka-${var.owner}-master"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.cka_training.id
    allocation_id = aws_eip.apiserver_ip.id
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.prefix}_apiserver_lb"
    }
  )
}

resource "aws_lb_target_group" "master_tg" {
  name        = "cka-${var.owner}-master"
  port        = 6443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc_kube.id
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.apiserver_lb.arn
  port              = "6443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.master_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "attach_masters" {
  count            = 3
  target_group_arn = aws_lb_target_group.master_tg.arn
  target_id        = element(aws_instance.masters.*.id, count.index)
  port             = 6443
}
