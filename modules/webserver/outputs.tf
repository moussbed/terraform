output "webserver_aws_ami_id" {
  value = data.aws_ami.latest-linux-amazon-machine-image.id
}
output "webserver_ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}