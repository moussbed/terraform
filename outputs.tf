output "aws_ami_id" {
  value = module.myapp-webserver.webserver_aws_ami_id
}
output "ec2_public_ip" {
  value = module.myapp-webserver.webserver_ec2_public_ip
}