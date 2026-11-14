terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Reference the existing Default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch the latest official Ubuntu 26.04 LTS (Resolute Raccoon) Free Tier AMI
data "aws_ami" "ubuntu_26_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's official AWS Account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Upload local SSH public key to AWS
resource "aws_key_pair" "deployer" {
  key_name   = "${var.instance_name}-key"
  public_key = file(var.public_key_path)
}

# Configure Security Group allowing Inbound HTTP (80) and SSH (22)
resource "aws_security_group" "nginx_sg" {
  name        = var.sg_name
  description = "Allow inbound HTTP and SSH traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name
  }
}

# Launch EC2 instance with user_data to install and configure Nginx
resource "aws_instance" "nginx_server" {
  ami                         = data.aws_ami.ubuntu_26_04.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.deployer.key_name
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo '${var.html_content}' > /var/www/html/index.html
              EOF

  tags = {
    Name = var.instance_name
  }
}

