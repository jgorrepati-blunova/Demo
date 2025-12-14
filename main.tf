terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source = "hashicorp/tls"
    }
    local = {
      source = "hashicorp/local"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  type = string
}

resource "tls_private_key" "rsa_4096" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_4096.public_key_openssh
}

# ⚠️ learning only — remove in real setups
resource "local_file" "private_key" {
  content         = tls_private_key.rsa_4096.private_key_pem
  filename        = var.key_name
  file_permission = "0400"
}

resource "aws_instance" "public_instance" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.key_pair.key_name

  tags = {
    Name = "EC2_instance"
  }
}
