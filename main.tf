terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  type    = string
  default = "github-actions-key"
}

resource "aws_instance" "ephemeral_ec2" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t3.micro"
  key_name      = var.key_name

  tags = {
    Name  = "ephemeral-ec2"
    Owner = "github-actions"
  }
}
