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


# resource "aws_instance" "demo-server" {
#   ami = data.aws_ami.my-ami.id
#   instance_type = "t2.micro"
#   key_name = "dpp"
# }
