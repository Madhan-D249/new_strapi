provider "aws" {
  region = var.region
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group to allow traffic
resource "aws_security_group" "strapimaxxy_sg" {
  name_prefix       = "strapimaxxy-sg"
  description = "Allow traffic for Strapi"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optional: SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "strapimaxxy-sg"
  }
}

# Launch EC2 with user data script
resource "aws_instance" "strapi_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  user_data                   = file("${path.module}/scripts/setup.sh")
  vpc_security_group_ids      = [aws_security_group.strapimaxxy_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "StrapiDockerEC2"
  }
}
