# Use Default Security Group
resource "aws_default_security_group" "myapp-default-sg" {
  vpc_id=var.vpc_id

  # incoming traffic 
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.my_ip]
  }
  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  # outgoing traffic 
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      prefix_list_ids = []
  }

  tags = {
       Name: "${var.env_prefix}-default-sg"
  }
}

# Query the lastest image of linux Amazon Machine Image(AMI)
data "aws_ami" "latest-linux-amazon-machine-image" {
  most_recent = true
  owners = ["137112412989"]
  filter {
    name = "name"
    values = ["amzn2-ami-kernel-*-x86_64-gp2"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# SSH Key Pair 
resource "aws_key_pair" "myapp-ssh-key-pair" {
 key_name = "server-myapp-key"
 public_key = file(var.public_key_location)
}

# EC2 (Elastic Compute Cloud)
resource "aws_instance" "myapp-server" {
   # Required
   ami = data.aws_ami.latest-linux-amazon-machine-image.id
   instance_type = var.instance_type

   #Optional
   subnet_id = var.subnet_id 
   vpc_security_group_ids = [aws_default_security_group.myapp-default-sg.id]
   availability_zone = var.availability_zone

   associate_public_ip_address = true
   key_name = aws_key_pair.myapp-ssh-key-pair.key_name

   # Execute command inside the ec2 instance
   # With this manner we don't have control.
   # We don't know if the commands were executed properly
   # Passing data to AWS
   user_data = file("entry-script.sh")

   tags = {
       Name: "${var.env_prefix}-server"
   }
}