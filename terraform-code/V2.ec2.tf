# terraform {
#   required_providers {
#     aws = {
#         source = "hashicorp/aws"
#         version = "~>5.0"
#     }
#   }
# }

# provider "aws" {
#   region = "us-east-1"
# }

# data "aws_ami" "my-ami" {
#   most_recent = true
#   owners = ["amazon"]

#   filter {
#     name = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
#   }

#   filter {
#     name = "virtualization-type"
#     values = ["hvm"]
#   }
# }

# resource "aws_instance" "demi-server" {
#   depends_on = [ aws_security_group.demi-sg ]
#   ami = data.aws_ami.my-ami.id
#   instance_type = "t2.micro"
#   key_name = "dpp"
#   vpc_security_group_ids = [aws_security_group.demi-sg.id]
#   subnet_id = aws_subnet.demi-public-subnet-1.id
# }

# resource "aws_security_group" "demi-sg" {
#   name        = "demo-sg"
#   description = "SSH Access"
#   vpc_id = aws_vpc.demi-vpc.id

#   ingress {
#     from_port = 22
#     to_port = 22
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "allow_ssh"
#   }
# }

