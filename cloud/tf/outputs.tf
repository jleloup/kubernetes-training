
output "apiserver_endpoint" {
  value = aws_eip.apiserver_ip.public_ip
}
