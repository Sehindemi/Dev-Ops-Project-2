terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "my-ami" {
  most_recent = true
  owners = ["amazon"]

#   filter {
#     name = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]
#   }

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-*-amd64-server-*"]
    }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "demi-server" {
  
  depends_on = [ aws_security_group.demi-sg ]
  ami = data.aws_ami.my-ami.id
  instance_type = "t2.micro"
  key_name = "dpp"
  vpc_security_group_ids = [aws_security_group.demi-sg.id]
  subnet_id = aws_subnet.demi-public-subnet-1.id
  for_each = toset(["Jenkins-master","Build-slave", "Ansible"])  
  tags = {
    Name = "${each.key}"
  }
}

resource "aws_security_group" "demi-sg" {
  name        = "demo-sg"
  description = "SSH Access"
  vpc_id = aws_vpc.demi-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_vpc" "demi-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "demi-vpc"
  }
}

resource "aws_subnet" "demi-public-subnet-1" {
  vpc_id = aws_vpc.demi-vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "demi-public-subnet-1"
  }
}

resource "aws_subnet" "demi-public-subnet-2" {
  vpc_id = aws_vpc.demi-vpc.id
  map_public_ip_on_launch = true
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "demi-public-subnet-2"
  }
}

resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.demi-vpc.id

  tags = {
    Name = "main-igw"
  }
}

resource "aws_route_table" "demi-public-route-table" {
  vpc_id = aws_vpc.demi-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }
  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "route-table-association" {
  subnet_id = aws_subnet.demi-public-subnet-1.id
  route_table_id = aws_route_table.demi-public-route-table.id
}

resource "aws_route_table_association" "route-table-association-2" {
  subnet_id = aws_subnet.demi-public-subnet-2.id
  route_table_id = aws_route_table.demi-public-route-table.id
}
