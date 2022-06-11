terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
    github = {
      source = "integrations/github"
	version = "~ 4.0"
  }
}
  required_version = "~> 1.0"

  backend "remote" {
    organization = "Terraform-GitHub-AWS-Project"

    workspaces {
      name = "demo-github-actions"
    }
  }
}

provider "github" {
token = "Qrog93kCW3jh2A.atlasv1.QDjhVEOY7lyEBiUU9NQWsLydyzBICzvWtSxjhjJuoCYgjQjgM6gnbaFA6SZ9w6SZihY"

provider "aws" {
  region = "us-east-1"
}



resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-09e67e426f25ce0d7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
