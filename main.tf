terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {
    type = string
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

resource "local_file" "private_key" {
    content = tls_private_key.rsa_4096.private_key_pem
    filename = var.key_name
}

resource "aws_instance" "public_instance" {
  ami           = "ami-0fa91bc90632c73c9"
  instance_type = "t3.micro"
  key_name = aws_key_pair.key_pair.key_name

  tags = {
    Name = "EC2_instance"
  }
}